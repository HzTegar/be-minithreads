<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Report;
use App\Models\Post;
use App\Models\Comment;
use App\Models\User;
// Hapus atau komentari import model kustom jika tidak digunakan
// use App\Models\Notification; 
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;

class ReportController extends Controller
{
    /**
     * 1. SUBMIT REPORT (User)
     * Mengirimkan laporan untuk postingan, komentar, atau user.
     * POST /api/report
     */
    public function store(Request $request)
    {
        $user = auth('api')->user();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'Sesi login tidak valid atau kadaluarsa.'
            ], 401);
        }

        $validator = Validator::make($request->all(), [
            'target_id'   => 'required',
            'target_type' => 'required|in:post,comment,user', 
            'reason'      => 'required|string|max:255',
            'description' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors'  => $validator->errors()
            ], 422);
        }

        // Cek dan petakan jenis entitas yang dilaporkan
        if ($request->target_type === 'post') {
            $target = Post::find($request->target_id);
            $targetOwnerId = $target ? $target->user_id : null;
        } elseif ($request->target_type === 'comment') {
            $target = Comment::find($request->target_id);
            $targetOwnerId = $target ? $target->user_id : null;
        } else {
            $target = User::find($request->target_id);
            $targetOwnerId = $target ? $target->id : null;
        }

        // Validasi eksistensi target di database
        if (!$target) {
            return response()->json([
                'success' => false,
                'message' => 'Target yang ingin dilaporkan tidak ditemukan.'
            ], 404);
        }

        $targetClass = $target->getMorphClass();

        // Mencegah pelaporan konten milik sendiri atau melaporkan diri sendiri
        if ($targetOwnerId === $user->id) {
            return response()->json([
                'success' => false,
                'message' => 'Kamu tidak bisa melaporkan konten milikmu sendiri atau melaporkan dirimu sendiri, bro!'
            ], 400);
        }

        // Mencegah duplikasi laporan dari user yang sama terhadap target yang sama
        $alreadyReported = Report::where('user_id', $user->id)
            ->where('target_id', $target->id)
            ->where('target_type', $targetClass)
            ->exists();

        if ($alreadyReported) {
            return response()->json([
                'success' => false,
                'message' => 'Kamu sudah melaporkan target ini sebelumnya, bro.'
            ], 400);
        }

        // Simpan Laporan ke Tabel Reports
        $report = Report::create([
            'user_id'     => $user->id,
            'target_id'   => $target->id,
            'target_type' => $targetClass, 
            'reason'      => $request->reason,
            'description' => $request->description,
            'status'      => 'pending',
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Laporan kamu berhasil dikirim dan akan segera ditinjau oleh tim moderator. Terima kasih, bro!',
            'data'    => $report
        ], 201);
    }

    /**
     * 2. LIST REPORTS (Staff Only)
     * Melihat semua laporan yang masuk.
     * GET /api/admin/reports
     */
    public function index(Request $request)
    {
        $user = auth('api')->user();
        
        if (!$user || (!$user->isAdmin() && !$user->isModerator())) {
            return response()->json(['success' => false, 'message' => 'Akses ditolak.'], 403);
        }

        $query = Report::with(['user', 'target']);

        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        if ($request->has('keyword')) {
            $keyword = $request->keyword;
            $query->where(function ($q) use ($keyword) {
                $q->where('reason', 'LIKE', "%{$keyword}%")
                  ->orWhere('description', 'LIKE', "%{$keyword}%");
            });
        }

        $reports = $query->latest()->paginate(15);

        return response()->json([
            'success' => true,
            'message' => 'Daftar laporan berhasil diambil.',
            'data'    => $reports
        ], 200);
    }

    /**
     * 3. SHOW REPORT DETAIL (Staff Only)
     * GET /api/admin/reports/{id}
     */
    public function show($id)
    {
        $user = auth('api')->user();
        
        if (!$user || (!$user->isAdmin() && !$user->isModerator())) {
            return response()->json(['success' => false, 'message' => 'Akses ditolak.'], 403);
        }

        $report = Report::with(['user', 'target', 'moderator'])->find($id);

        if (!$report) {
            return response()->json(['success' => false, 'message' => 'Laporan tidak ditemukan.'], 404);
        }

        return response()->json([
            'success' => true,
            'data'    => $report
        ], 200);
    }

    /**
     * 4. RESOLVE/UPDATE REPORT (Medium Level: Warning, Notification, & Point Deduction)
     * PUT /api/admin/reports/{id}
     */
    public function update(Request $request, $id)
    {
        $user = auth('api')->user();
        
        if (!$user || (!$user->isAdmin() && !$user->isModerator())) {
            return response()->json(['success' => false, 'message' => 'Akses ditolak.'], 403);
        }

        $report = Report::with(['user', 'target'])->find($id);
        if (!$report) {
            return response()->json(['success' => false, 'message' => 'Laporan tidak ditemukan.'], 404);
        }

        $validator = Validator::make($request->all(), [
            'status'          => 'required|in:reviewed,resolved,rejected',
            'moderator_notes' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'errors' => $validator->errors()], 422);
        }

        return DB::transaction(function () use ($request, $report, $user) {
            
            $actionMessage = ".";

            // Eksekusi logika penegakan kebijakan jika laporan disetujui (status diubah menjadi 'resolved')
            if ($request->status === 'resolved' && $report->status !== 'resolved') {
                
                // ==========================================
                // A. PROSES PENGURANGAN POIN & NOTIFIKASI TERLAPOR
                // ==========================================
                $target = $report->target;
                $reportedUser = null;

                if ($target) {
                    if ($report->target_type === Post::class || $report->target_type === Comment::class) {
                        $reportedUser = User::find($target->user_id);
                    } elseif ($report->target_type === User::class) {
                        $reportedUser = $target;
                    }

                    if ($reportedUser) {
                        // Menyesuaikan nama kolom menjadi reputation_points dan mengunci batas minimal di angka 0
                        $newPoints = max(0, $reportedUser->reputation_points - 20);
                        $reportedUser->update(['reputation_points' => $newPoints]); 

                        // PERBAIKAN: Menggunakan sistem Database Notification bawaan Laravel untuk Terlapor
                        $reportedUser->notify(new \App\Notifications\WarningNotification($request->moderator_notes));

                        $actionMessage = " poin reputasi terlapor berhasil dikurangi 20, dan notifikasi peringatan telah dikirim.";
                    }
                }

                // ==========================================
                // B. PROSES NOTIFIKASI KONFIRMASI PELAPOR
                // ==========================================
                $reporter = $report->user; 
                if ($reporter) {
                    // PERBAIKAN: Menggunakan sistem Database Notification bawaan Laravel untuk Pelapor
                    $reporter->notify(new \App\Notifications\ReportApprovedNotification());
                }
            }

            // 3. Perbarui Status Utama Laporan
            $report->update([
                'status'          => $request->status,
                'moderator_notes' => $request->moderator_notes,
                'resolved_by'     => $user->id,
            ]);

            return response()->json([
                'success' => true,
                'message' => "Status laporan berhasil diperbarui{$actionMessage}",
                'data'    => $report
            ], 200);
        });
    }
}
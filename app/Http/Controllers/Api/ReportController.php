<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Report;
use App\Models\Post;
use App\Models\Comment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ReportController extends Controller
{
    /**
     * 1. SUBMIT REPORT (User)
     * Mengirimkan laporan untuk postingan atau komentar.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'target_id'   => 'required',
            'target_type' => 'required|in:post,comment',
            'reason'      => 'required|string|max:255',
            'description' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $user = auth('api')->user();

        // Cek apakah konten ada
        if ($request->target_type === 'post') {
            $target = Post::find($request->target_id);
            $targetClass = Post::class;
        } else {
            $target = Comment::find($request->target_id);
            $targetClass = Comment::class;
        }

        if (!$target) {
            return response()->json([
                'success' => false,
                'message' => 'Konten yang ingin dilaporkan tidak ditemukan.'
            ], 404);
        }

        // Mencegah pelaporan konten milik sendiri
        if ($target->user_id === $user->id) {
            return response()->json([
                'success' => false,
                'message' => 'Kamu tidak bisa melaporkan konten milikmu sendiri, bro!'
            ], 400);
        }

        // Simpan Laporan
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
            'data' => $report
        ], 201);
    }

    /**
     * 2. LIST REPORTS (Staff Only)
     * Melihat semua laporan yang masuk.
     */
    public function index(Request $request)
    {
        $user = auth('api')->user();
        if (!$user->isAdmin() && !$user->isModerator()) {
            return response()->json(['success' => false, 'message' => 'Akses ditolak.'], 403);
        }

        $query = Report::with(['user', 'target.user']);

        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        $reports = $query->latest()->paginate(15);

        return response()->json([
            'success' => true,
            'message' => 'Daftar laporan berhasil diambil.',
            'data' => $reports
        ], 200);
    }

    /**
     * 3. SHOW REPORT DETAIL (Staff Only)
     */
    public function show($id)
    {
        $user = auth('api')->user();
        if (!$user->isAdmin() && !$user->isModerator()) {
            return response()->json(['success' => false, 'message' => 'Akses ditolak.'], 403);
        }

        $report = Report::with(['user', 'target.user', 'moderator'])->find($id);

        if (!$report) {
            return response()->json(['success' => false, 'message' => 'Laporan tidak ditemukan.'], 404);
        }

        return response()->json([
            'success' => true,
            'data' => $report
        ], 200);
    }

    /**
     * 4. RESOLVE/UPDATE REPORT (Staff Only)
     * Mengubah status laporan (reviewed, resolved, rejected).
     */
    public function update(Request $request, $id)
    {
        $user = auth('api')->user();
        if (!$user->isAdmin() && !$user->isModerator()) {
            return response()->json(['success' => false, 'message' => 'Akses ditolak.'], 403);
        }

        $report = Report::find($id);
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

        $report->update([
            'status'          => $request->status,
            'moderator_notes' => $request->moderator_notes,
            'resolved_by'     => $user->id,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Status laporan berhasil diperbarui.',
            'data' => $report
        ], 200);
    }
}

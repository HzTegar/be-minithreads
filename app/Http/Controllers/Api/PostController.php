<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Post;
use App\Models\Comment;
use App\Models\PostEditHistory; // <-- WAJIB IMPORT INI, BRO!
use App\Services\ReputationService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\DB;

class PostController extends Controller
{
    /**
     * 1. LIST SEMUA POSTINGAN (DENGAN PAGINATION & SEARCH)
     */
    public function index(Request $request)
    {
        $query = Post::with(['user', 'category', 'tags'])->latest();

        // Filter berdasarkan kategori (slug)
        if ($request->has('category')) {
            $query->whereHas('category', function ($q) use ($request) {
                $q->where('slug', $request->category);
            });
        }

        // Filter berdasarkan tag (slug)
        if ($request->has('tag')) {
            $query->whereHas('tags', function ($q) use ($request) {
                $q->where('slug', $request->tag);
            });
        }

        // Filter berdasarkan user (username)
        if ($request->has('user')) {
            $query->whereHas('user', function ($q) use ($request) {
                $q->where('username', $request->user);
            });
        }

        $posts = $query->paginate(10);

        return response()->json([
            'success' => true,
            'message' => 'Daftar postingan berhasil diambil.',
            'data'    => $posts
        ], 200);
    }

    /**
     * 2. DETAIL POSTINGAN (SHOW) - DENGAN KOMENTAR BERSARANG
     */
    public function show($id)
    {
        $user = auth('api')->user();
        
        $query = Post::with([
            'user', 
            'category', 
            'tags', 
            'comments' => function($query) {
                $query->whereNull('parent_id') // Ambil komentar utama saja
                      ->with(['user', 'replies.user'])
                      ->withCount('likes'); // Eager load user & balasan
            }
        ])->withCount('likes');

        // Jika yang akses adalah Admin atau Moderator, tampilkan riwayat edit
        if ($user && ($user->isAdmin() || $user->isModerator())) {
            $query->with(['edit_histories' => function($q) {
                $q->with('user')->latest();
            }]);
        }

        $post = $query->find($id);

        if (!$post) {
            return response()->json([
                'success' => false,
                'message' => 'Postingan tidak ditemukan.'
            ], 404);
        }

        // Increment view count secara otomatis setiap kali detail dibuka
        $post->increment('view_count');

        return response()->json([
            'success' => true,
            'message' => 'Detail postingan berhasil diambil.',
            'data'    => $post
        ], 200);
    }

    /**
     * 3. BUAT POSTINGAN BARU (CREATE)
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'category_id' => 'required|exists:categories,id',
            'title'       => 'required|string|max:300',
            'body'        => 'required|string',
            'tags'        => 'nullable|array',
            'tags.*'      => 'string|max:50'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $user = auth('api')->user();
        
        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'Sesi login tidak valid atau kadaluarsa.'
            ], 401);
        }

        // CEK BATASAN POIN: Minimal 20 poin untuk posting (Kecuali Admin/Moderator)
        if (!$user->isAdmin() && !$user->isModerator() && $user->reputation_points < ReputationService::MIN_POINTS_TO_POST) {
            return response()->json([
                'success' => false,
                'message' => 'Waduh! Poin kamu belum cukup untuk posting, bro. Minimal kamu harus punya ' . ReputationService::MIN_POINTS_TO_POST . ' poin. Yuk, aktif dulu ngevote atau ngelike konten orang lain!'
            ], 403);
        }

        return DB::transaction(function () use ($request, $user) {
            $post = $user->posts()->create([
                'category_id' => $request->category_id,
                'title'       => $request->title,
                'slug'        => Str::slug($request->title) . '-' . Str::random(5),
                'body'        => $request->body,
                'status'      => 'open',
                'edit_count'  => 0,
            ]);

            // Menyinkronkan hubungan tags ke tabel pivot jika dikirimkan
            if ($request->has('tags')) {
                $tagIds = [];
                foreach ($request->tags as $tagName) {
                    $tag = \App\Models\Tag::firstOrCreate(
                        ['name' => $tagName],
                        ['slug' => Str::slug($tagName), 'color' => '#3B82F6']
                    );
                    $tagIds[] = $tag->id;
                }
                $post->tags()->sync($tagIds);
            }

            return response()->json([
                'success' => true,
                'message' => 'Pertanyaan kamu berhasil diterbitkan, bro!',
                'data'    => $post->load('tags') // Memuat tag yang baru ditempel agar muncul di response
            ], 201);
        });
    }

    /**
     * 4. EDIT POST (UPDATE) - SUDAH FIX 100% TERINTEGRASI USER_ID HISTORY
     */
    public function update(Request $request, $id)
    {
        $post = Post::find($id);

        if (!$post) {
            return response()->json([
                'success' => false,
                'message' => 'Postingan tidak ditemukan.'
            ], 404);
        }

        $user = auth('api')->user();
        if (!$user || $user->id !== $post->user_id) {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak! Kamu bukan pemilik postingan ini, bro.'
            ], 403);
        }

        // Cek batasan edit menggunakan kolom edit_count bawaan database (maksimal 3 kali)
        if ($post->edit_count >= 3) {
            return response()->json([
                'success' => false,
                'message' => 'Slot edit habis! Kamu hanya dibatasi mengedit postingan maksimal 3 kali, bro.'
            ], 400);
        }

        $validator = Validator::make($request->all(), [
            'category_id' => 'required|exists:categories,id',
            'title'       => 'required|string|max:300',
            'body'        => 'required|string',
            'tags'        => 'nullable|array',
            'tags.*'      => 'string|max:50'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        return DB::transaction(function () use ($request, $post, $user) {
            // PERBAIKAN: Menyertakan 'user_id' agar log mencatat penanggung jawab perubahan
            $post->edit_histories()->create([
                'user_id'     => $user->id, 
                'old_title'   => $post->title,
                'new_title'   => $request->title,
                'old_body'    => $post->body,
                'new_body'    => $request->body,
                'edit_number' => $post->edit_count + 1,
            ]);

            $post->update([
                'category_id' => $request->category_id,
                'title'       => $request->title,
                'slug'        => Str::slug($request->title) . '-' . Str::random(5),
                'body'        => $request->body,
                'edit_count'  => $post->edit_count + 1,
            ]);

            if ($request->has('tags')) {
                $tagIds = [];
                foreach ($request->tags as $tagName) {
                    $tag = \App\Models\Tag::firstOrCreate(
                        ['name' => $tagName],
                        ['slug' => Str::slug($tagName), 'color' => '#3B82F6']
                    );
                    $tagIds[] = $tag->id;
                }
                $post->tags()->sync($tagIds);
            }

            return response()->json([
                'success' => true,
                'message' => 'Postingan berhasil diperbarui, bro!',
                'data'    => $post->load(['tags', 'category'])
            ], 200);
        });
    }

    /**
     * 5. HAPUS POSTINGAN (DELETE) - SOFT DELETE
     */
    public function destroy($id)
    {
        $post = Post::find($id);

        if (!$post) {
            return response()->json([
                'success' => false,
                'message' => 'Postingan tidak ditemukan.'
            ], 404);
        }

        $user = auth('api')->user();

        // Otoritas: Cek apakah user adalah pemilik post, Admin, atau Moderator
        if ($user->id !== $post->user_id && !$user->isAdmin() && !$user->isModerator()) {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak! Kamu tidak punya wewenang menghapus postingan ini, bro.'
            ], 403);
        }

        // Logic: Jika User Biasa (Pemilik) yang hapus -> Soft Delete. Jika Admin/Mod yang hapus -> Force Delete (Hard Delete)
        if ($user->isAdmin() || $user->isModerator()) {
            $post->forceDelete(); // Menghapus permanen dari database
            return response()->json([
                'success' => true,
                'message' => 'Postingan telah dihapus secara PERMANEN oleh Staf, bro!'
            ], 200);
        }

        $post->delete(); // Soft delete (hanya isi kolom deleted_at)

        return response()->json([
            'success' => true,
            'message' => 'Postingan berhasil dihapus (Soft Delete), bro!'
        ], 200);
    }

    /**
     * 6. MEMILIH JAWABAN TERBAIK (TOGGLE ACCEPTED ANSWER)
     * POST /api/posts/{postId}/comments/{commentId}/toggle-accepted
     */
    public function toggleAcceptedAnswer(Request $request, $postId, $commentId)
    {
        $post = Post::find($postId);
        $comment = Comment::with('user')->find($commentId);

        if (!$post || !$comment) {
            return response()->json([
                'success' => false,
                'message' => 'Post atau Komentar tidak ditemukan.'
            ], 404);
        }

        $user = auth('api')->user();
        if (!$user || $user->id !== $post->user_id) {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak! Cuma pemilik pertanyaan yang bisa milih jawaban terbaik, bro.'
            ], 403);
        }

        if ($comment->post_id !== $post->id) {
            return response()->json([
                'success' => false,
                'message' => 'Komentar ini bukan bagian dari postingan ini.'
            ], 400);
        }

        return DB::transaction(function () use ($post, $comment, $user) {
            $oldAcceptedAnswerId = $post->accepted_answer_id;
            $service = app(ReputationService::class);

            // Kondisi Toggle Off: Membatal status jawaban terbaik yang sudah ada
            if ($oldAcceptedAnswerId === $comment->id) {
                $post->update(['accepted_answer_id' => null, 'is_answered' => false]);
                $comment->update(['is_accepted' => false]);

                if ($comment->user) {
                    $service->deductPoints(
                        $comment->user,
                        ReputationService::POINTS_ACCEPTED_ANSWER,
                        'accepted_answer_revoked',
                        $comment->id,
                        "Jawaban terbaik dicabut pada post: {$post->title}"
                    );
                }

                return response()->json([
                    'success' => true,
                    'message' => 'Status jawaban terbaik berhasil dicabut, bro.',
                    'data' => ['is_accepted' => false]
                ]);
            }

            // Kondisi Rebutan/Penggantian: Cabut poin dari jawaban terbaik lama (jika ada)
            if ($oldAcceptedAnswerId) {
                $oldComment = Comment::with('user')->find($oldAcceptedAnswerId);
                if ($oldComment) {
                    $oldComment->update(['is_accepted' => false]);
                    if ($oldComment->user) {
                        $service->deductPoints(
                            $oldComment->user,
                            ReputationService::POINTS_ACCEPTED_ANSWER,
                            'accepted_answer_replaced',
                            $oldComment->id,
                            "Jawaban terbaik digantikan pada post: {$post->title}"
                        );
                    }
                }
            }

            // Menetapkan jawaban baru sebagai yang terbaik
            $post->update(['accepted_answer_id' => $comment->id, 'is_answered' => true]);
            $comment->update(['is_accepted' => true]);

            // Kirim Notifikasi ke pemilik jawaban
            if ($comment->user && $comment->user_id !== $user->id) {
                $comment->user->notify(new \App\Notifications\AnswerAcceptedNotification($post, $comment, $user));
            }

            if ($comment->user) {
                $service->awardPoints(
                    $comment->user,
                    ReputationService::POINTS_ACCEPTED_ANSWER,
                    'accepted_answer_received',
                    $comment->id,
                    "Selamat! Jawabanmu terpilih sebagai yang terbaik di: {$post->title}"
                );
            }

            return response()->json([
                'success' => true,
                'message' => 'Mantap! Jawaban terbaik berhasil dipilih.',
                'data' => ['is_accepted' => true]
            ], 200);
        });
    }

    /**
     * 7. MELIHAT RIWAYAT EDIT POST (Khusus Admin & Moderator)
     * GET /api/posts/{id}/history
     */
    public function viewHistory($id)
    {
        $post = Post::find($id);
        if (!$post) {
            return response()->json(['success' => false, 'message' => 'Postingan tidak ditemukan.'], 404);
        }

        $user = auth('api')->user();
        if (!$user || (!$user->isAdmin() && !$user->isModerator())) {
            return response()->json(['success' => false, 'message' => 'Akses ditolak! Hanya Staf yang bisa intip riwayat edit, bro.'], 403);
        }

        $histories = $post->edit_histories()->with('user')->latest()->get();

        return response()->json([
            'success' => true,
            'message' => 'Log riwayat pengeditan berhasil diambil oleh Staf, bro!',
            'total_edited' => $histories->count(),
            'data' => $histories
        ], 200);
    }

    /**
     * 10. TOGGLE ARCHIVE (CLOSE/REOPEN)
     * POST /api/posts/{id}/toggle-archive
     */
    public function toggleArchive($id)
    {
        $post = Post::find($id);
        if (!$post) {
            return response()->json(['success' => false, 'message' => 'Postingan tidak ditemukan.'], 404);
        }

        $user = auth('api')->user();
        if (!$user || $user->id !== $post->user_id) {
            return response()->json(['success' => false, 'message' => 'Hanya pemilik postingan yang bisa mengarsipkan ini.'], 403);
        }

        // Jika mau di-close (archive) - Tambahkan syarat harus sudah dijawab (is_answered)
        if ($post->status !== 'closed' && !$post->is_answered) {
            return response()->json([
                'success' => false,
                'message' => 'Postingan belum bisa ditutup karena belum ada jawaban terbaik yang dipilih, bro.'
            ], 400);
        }

        // Jika sudah di-close, mau di-reopen
        if ($post->status === 'closed') {
            if ($post->is_closed_permanently) {
                return response()->json([
                    'success' => false,
                    'message' => 'Postingan sudah terarsip selamanya karena sudah lebih dari 24 jam, bro.'
                ], 400);
            }

            $post->update([
                'status' => 'open',
                'closed_at' => null
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Postingan berhasil dipublikasikan kembali!',
                'data' => $post
            ], 200);
        }

        // Jika mau di-close (archive)
        $post->update([
            'status' => 'closed',
            'closed_at' => now()
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Postingan berhasil diarsipkan. Kamu punya waktu 24 jam jika ingin membukanya kembali.',
            'data' => $post
        ], 200);
    }
}

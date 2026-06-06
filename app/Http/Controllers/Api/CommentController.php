<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Post;
use App\Models\Comment;
use App\Models\CommentEditHistory;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class CommentController extends Controller
{
    /**
     * MENAMBAHKAN KOMENTAR / JAWABAN BARU / BALASAN (REPLY)
     * POST /api/posts/{postId}/comments
     */
    public function store(Request $request, $postId)
    {
        // 1. Validasi pastikan Postingan yang dikomentari memang ada
        $post = Post::find($postId);

        if (!$post) {
            return response()->json([
                'success' => false,
                'message' => 'Postingan tidak ditemukan.'
            ], 404);
        }

        // Proteksi: Tidak boleh komen di postingan yang sudah di-close (archived)
        if ($post->status === 'closed') {
            return response()->json([
                'success' => false,
                'message' => 'Postingan ini sudah diarsipkan/ditutup, kamu tidak bisa menambah komentar lagi, bro.'
            ], 403);
        }

        // 2. Validasi input body komentar & parent_id
        $validator = Validator::make($request->all(), [
            'body'      => 'required|string',
            'parent_id' => 'nullable|exists:comments,id', // Jika dikirim, ID wajib terdaftar di tabel comments
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        // 3. Ambil data user yang sedang login via API
        $user = auth('api')->user();

        // 4. Logika Batasan: Jika yang komentar adalah pemilik postingan, batasi maksimal 4 komentar per postingan
        if ($post->user_id === $user->id) {
            $ownerCommentCount = Comment::where('post_id', $post->id)
                ->where('user_id', $user->id)
                ->count();

            if ($ownerCommentCount >= 4) {
                return response()->json([
                    'success' => false,
                    'message' => 'Batas komentar tercapai! Sebagai pemilik postingan, kamu hanya dibatasi memberikan 4 komentar/jawaban pada postinganmu sendiri.'
                ], 400);
            }
        }

        // 5. Simpan data komentar ke database
        $comment = Comment::create([
            'post_id'     => $post->id,
            'user_id'     => $user->id,
            'parent_id'   => $request->parent_id, // Mengakomodasi komentar utama (null) maupun reply (UUID)
            'body'        => $request->body,
            'is_accepted' => false, 
        ]);

        // --- LOGIKA NOTIFIKASI ---
        if ($request->filled('parent_id')) {
            // Jika ini adalah REPLY
            $parentComment = Comment::find($request->parent_id);
            if ($parentComment && $parentComment->user_id !== $user->id) {
                $parentComment->user->notify(new \App\Notifications\CommentRepliedNotification($post, $comment, $user));
            }
        } else {
            // Jika ini adalah KOMENTAR UTAMA
            if ($post->user_id !== $user->id) {
                $post->user->notify(new \App\Notifications\NewCommentNotification($post, $comment, $user));
            }
        }

        // 6. Kondisional pesan sukses
        $message = $request->filled('parent_id')
            ? 'Balasan kamu berhasil dikirim, bro!'
            : 'Komentar atau jawaban berhasil dikirim!';

        // 7. Kembalikan response JSON beserta UUID Comment yang baru tercipta
        return response()->json([
            'success' => true,
            'message' => $message,
            'data'    => $comment->load('user') // Eager load user agar profil pembuat komen langsung muncul
        ], 201);
    }

    /**
     * MENGEDIT ISI KOMENTAR / JAWABAN
     * PUT /api/comments/{id}
     */
    public function update(Request $request, $id)
    {
        // 1. Cari komentar berdasarkan ID UUID
        $comment = Comment::find($id);

        if (!$comment) {
            return response()->json([
                'success' => false,
                'message' => 'Komentar tidak ditemukan, bro.'
            ], 404);
        }

        // 2. Ambil data user yang sedang login
        $user = auth('api')->user();
        
        // Proteksi: Hanya pemilik asli komentar yang boleh mengedit kodenya
        if (!$user || $user->id !== $comment->user_id) {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak! Kamu bukan pemilik komentar ini, bro.'
            ], 403);
        }

        // --- FIX: BATASAN EDIT KOMENTAR (MAKSIMAL 1 KALI) ---
        // Kita cek jumlah history edit yang sudah ada
        if ($comment->edit_histories()->count() >= 1) {
            return response()->json([
                'success' => false,
                'message' => 'Slot edit habis! Kamu hanya dibatasi mengedit komentar 1 kali per postingan, bro.'
            ], 400);
        }

        // 3. Validasi input teks body (disesuaikan menggunakan 'body' bukan 'content')
        $validator = Validator::make($request->all(), [
            'body' => 'required|string', 
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        // 4. Jika isinya sama persis dengan yang lama, tidak perlu disimpan ke history
        if ($comment->body === $request->body) {
            return response()->json([
                'success' => true,
                'message' => 'Tidak ada perubahan pada komentar, bro!',
                'data' => $comment
            ], 200);
        }

        // 5. Gunakan Database Transaction agar proses aman dan tidak korup di database
        return DB::transaction(function () use ($request, $comment, $user) {
            
            // Hitung ini adalah editan yang ke-berapa untuk komentar ini
            $nextEditNumber = $comment->edit_histories()->count() + 1;

            // Simpan data lama ke tabel comment_edit_histories sebelum data utama berubah
            $comment->edit_histories()->create([
                'user_id'     => $user->id,
                'old_content' => $comment->body,        // FIX: mengambil dari properti $comment->body yang ada di database
                'new_content' => $request->body,        // FIX: mengambil dari input $request->body
                'edit_number' => $nextEditNumber,   
            ]);

            // Update isi komentar utama dan ubah is_edited menjadi true (1)
            $comment->update([
                'body'      => $request->body,          // FIX: mengubah kolom 'body' pada tabel comments
                'is_edited' => true,                    // Label penanda "edited" aktif!
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Komentar berhasil diperbarui dan riwayat telah dicatat, bro!',
                'data'     => $comment
            ], 200);
        });
    }

    /**
     * MENGHAPUS KOMENTAR / JAWABAN
     * DELETE /api/comments/{id}
     */
    public function destroy($id)
    {
        // 1. Cari komentarnya di database
        $comment = Comment::find($id);

        if (!$comment) {
            return response()->json([
                'success' => false,
                'message' => 'Komentar tidak ditemukan, bro.'
            ], 404);
        }

        // 2. Ambil data user admin yang sedang login
        $user = auth('api')->user();

        // Validasi Otoritas: Kunci akses hanya untuk Admin
        if (!$user || !$user->isAdmin()) {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak! Hanya Admin yang bisa menghapus komentar, bro.'
            ], 403);
        }

        // 3. Jalankan perintah hapus
        $comment->delete();

        return response()->json([
            'success' => true,
            'message' => 'Komentar berhasil dihapus secara permanen oleh Admin, bro!'
        ], 200);
    }

    /**
     * Melihat Log Riwayat Edit Komentar (Khusus Admin & Moderator)
     * URL: GET /api/comments/{id}/history
     */
    public function viewHistory($id)
    {
        // 1. Pastikan komentarnya eksis
        $comment = Comment::find($id);
        if (!$comment) {
            return response()->json([
                'success' => false,
                'message' => 'Komentar tidak ditemukan, bro.'
            ], 404);
        }

        // 2. Ambil user yang merequest
        $user = auth('api')->user();

        // Proteksi: Cek apakah pengintip log ini adalah Admin atau Moderator
        if (!$user || (!$user->isAdmin() && !$user->isModerator())) {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak! Log riwayat edit ini rahasia, hanya untuk Admin/Moderator, bro.'
            ], 403);
        }

        // 3. Ambil seluruh riwayat editan komentar ini beserta data user yang mengubahnya
        $histories = $comment->edit_histories()->with('user')->latest()->get();

        return response()->json([
            'success' => true,
            'message' => 'Log riwayat komentar berhasil diambil, bro!',
            'total_edited' => $histories->count(),
            'data' => $histories
        ], 200);
    }
}    
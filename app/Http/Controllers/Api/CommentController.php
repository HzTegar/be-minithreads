<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Post;
use App\Models\Comment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Gate;

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
     * Batasan: Hanya pemilik, dan hanya boleh 1 kali edit per postingan untuk 1 akun
     */
    public function update(Request $request, $id)
    {
        // 1. Validasi Input Body
        $validator = Validator::make($request->all(), [
            'body' => 'required|string'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors'  => $validator->errors()
            ], 422);
        }

        // Ambil data komentar yang mau diedit beserta data post-nya
        $comment = Comment::findOrFail($id);

        // 2. Proteksi Keamanan: Cek hak akses menggunakan Policy (CommentPolicy)
        if (Gate::denies('update', $comment)) {
            return response()->json([
                'success' => false,
                'message' => 'Kamu tidak berhak mengedit komentar ini, bro!'
            ], 403);
        }

        // 3. Logika Batasan Forum: Cek apakah komentar ini sudah pernah diedit
        if ($comment->is_edited) {
            return response()->json([
                'success' => false,
                'message' => 'Slot edit habis! Kamu hanya dibatasi mengedit komentar 1 kali per postingan, bro.'
            ], 400);
        }

        return \Illuminate\Support\Facades\DB::transaction(function () use ($request, $comment) {
            // Log history sebelum diupdate
            $comment->editHistories()->create([
                'old_body' => $comment->body,
                'new_body' => $request->body,
            ]);

            // 4. Eksekusi Perubahan Data
            $comment->update([
                'body'      => $request->body,
                'is_edited' => true,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Komentar berhasil diperbarui, bro!',
                'data'    => [
                    'id'        => $comment->id,
                    'body'      => $comment->body,
                    'is_edited' => true,
                    'status'    => 'edited'
                ]
            ], 200);
        });
    }

    /**
     * MENGHAPUS KOMENTAR / JAWABAN (SOFT DELETE)
     * DELETE /api/comments/{id}
     * Batasan: Hanya untuk Admin dan Moderator
     */
    public function destroy($id)
    {
        $comment = Comment::findOrFail($id);

        // Proteksi Keamanan: Cek hak akses menggunakan Policy (CommentPolicy)
        // Memastikan hanya user dengan role 'admin' atau 'moderator' yang bisa lewat
        if (Gate::denies('delete', $comment)) {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak! Hanya Admin atau Moderator yang bisa menghapus komentar ini.'
            ], 403);
        }

        // Eksekusi Soft Delete (Hanya mengisi kolom deleted_at di database tanpa menghapus fisik)
        $comment->delete();

        return response()->json([
            'success' => true,
            'message' => 'Komentar berhasil dihapus oleh staf (Soft Delete), bro!'
        ], 200);
    }
}
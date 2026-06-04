<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Post;
use App\Models\Comment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class CommentController extends Controller
{
    /**
     * MENAMBAHKAN KOMENTAR / JAWABAN BARU
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

        // 2. Validasi input body komentar
        $validator = Validator::make($request->all(), [
            'body' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        // 3. Ambil data user yang sedang login via API
        $user = auth('api')->user();

        // 4. Simpan data komentar ke database
        $comment = Comment::create([
            'post_id'     => $post->id,
            'user_id'     => $user->id,
            'body'        => $request->body,
            'is_accepted' => false, // Default awal tentu saja belum menjadi jawaban terbaik
        ]);

        // 5. Kembalikan response JSON beserta UUID Comment yang baru tercipta
        return response()->json([
            'success' => true,
            'message' => 'Komentar atau jawaban berhasil dikirim!',
            'data'    => $comment
        ], 201);
    }
}
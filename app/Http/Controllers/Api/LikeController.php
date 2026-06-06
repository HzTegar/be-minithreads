<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Post;
use App\Models\Comment;
use App\Models\Like;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class LikeController extends Controller
{
    /**
     * TOGGLE LIKE (LIKE/UNLIKE)
     * Digunakan untuk menyukai postingan atau komentar (Polymorphic)
     */
    public function toggleLike(Request $request)
    {
        // 1. Validasi Input
        $validator = Validator::make($request->all(), [
            'target_id'   => 'required',
            'target_type' => 'required|in:post,comment',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors'  => $validator->errors()
            ], 422);
        }

        $user = auth('api')->user();

        // 2. Tentukan Model Target
        if ($request->target_type === 'post') {
            $model = Post::find($request->target_id);
            $modelClass = Post::class;
        } else {
            $model = Comment::find($request->target_id);
            $modelClass = Comment::class;
        }

        if (!$model) {
            return response()->json([
                'success' => false,
                'message' => 'Konten tidak ditemukan, bro.'
            ], 404);
        }

        // 3. Cek apakah sudah pernah di-like oleh user ini
        $existingLike = Like::where('user_id', $user->id)
                            ->where('target_id', $model->id)
                            ->where('target_type', $modelClass)
                            ->first();

        if ($existingLike) {
            // UNLIKE: Hapus data like
            $existingLike->delete();
            return response()->json([
                'success' => true,
                'message' => ($request->target_type === 'post' ? 'Post' : 'Komentar') . ' berhasil batal di-like, bro!',
                'is_liked' => false,
                'likes_count' => $model->likes()->count()
            ], 200);
        }

        // LIKE: Buat data like baru
        Like::create([
            'user_id'     => $user->id,
            'target_id'   => $model->id,
            'target_type' => $modelClass,
        ]);

        // Kirim Notifikasi jika yang di-like adalah POSTINGAN dan bukan milik sendiri
        if ($request->target_type === 'post' && $model->user_id !== $user->id) {
            $model->user->notify(new \App\Notifications\PostLikedNotification($model, $user));
        }

        return response()->json([
            'success' => true,
            'message' => ($request->target_type === 'post' ? 'Post' : 'Komentar') . ' berhasil di-like, bro!',
            'is_liked' => true,
            'likes_count' => $model->likes()->count()
        ], 201);
    }
}

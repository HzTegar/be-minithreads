<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Post;
use App\Models\Comment;
use App\Models\Like;
use App\Services\ReputationService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;
use Log;

class LikeController extends Controller
{
    /**
     * TOGGLE LIKE (LIKE/UNLIKE)
     */
    public function handleLike(Request $request)
    {
        // 1. Validasi Input Parameter
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
        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'User tidak terautentikasi, bro.'
            ], 401);
        }

        // 2. Tentukan Model Target Pengujian
        if ($request->target_type === 'post') {
            $model = Post::find($request->target_id);
        } else {
            $model = Comment::find($request->target_id);
        }

        if (!$model) {
            return response()->json([
                'success' => false,
                'message' => 'Konten tidak ditemukan, bro.'
            ], 404);
        }

        // Ambil representasi string nama model yang valid untuk kolom database
        $modelClass = $model->getMorphClass();

        return DB::transaction(function () use ($request, $user, $model, $modelClass) {
            $service = app(ReputationService::class);
            
            // 3. Cek Eksistensi Data Like Sebelumnya
            $existingLike = Like::where('user_id', $user->id)
                                ->where('target_id', $model->id)
                                ->where('target_type', $modelClass)
                                ->first();

            if ($existingLike) {
                // RUN UNLIKE ACTION
                $existingLike->delete();

                // Pengurangan poin untuk aktivitas pembatalan menyukai konten
                if ($request->target_type === 'post') {
                    $title = $model->title ?? 'Postingan Tanpa Judul';
                    
                    // Fallback ganda: Mengirimkan ID murni untuk mencocokkan arsitektur internal service
                    $service->deductPoints(
                        $user,
                        ReputationService::POINTS_LIKE ?? 10,
                        'post_unliked',
                        $model->id, 
                        "Batal menyukai postingan: {$title}"
                    );
                }

                $likesCount = Like::where('target_id', $model->id)
                                ->where('target_type', $modelClass)
                                ->count();

                return response()->json([
                    'success' => true,
                    'message' => ($request->target_type === 'post' ? 'Post' : 'Komentar') . ' berhasil batal di-like, bro!',
                    'is_liked' => false,
                    'likes_count' => $likesCount
                ], 200);
            }

            // RUN LIKE ACTION
            Like::create([
                'user_id'     => $user->id,
                'target_id'   => $model->id,
                'target_type' => $modelClass,
            ]);

            // Penambahan poin reputasi pengguna
            if ($request->target_type === 'post') {
                $title = $model->title ?? 'Postingan Tanpa Judul';
                
                $service->awardPoints(
                    $user,
                    ReputationService::POINTS_LIKE ?? 10,
                    'post_liked',
                    $model->id,
                    "Menyukai postingan: {$title}"
                );
            }

            // PERBAIKAN UTAMA: Amankan proses pengiriman notifikasi dengan blok Try-Catch
            try {
                if (isset($model->user_id) && $model->user_id !== $user->id) {
                    if ($request->target_type === 'post' && !empty($model->user)) {
                        $model->user->notify(new \App\Notifications\PostLikedNotification($model, $user));
                    } elseif ($request->target_type === 'comment' && !empty($model->user)) {
                        if (class_exists('\App\Notifications\CommentLikedNotification')) {
                            $model->user->notify(new \App\Notifications\CommentLikedNotification($model, $user));
                        }
                    }
                }
            } catch (\Exception $e) {
                // Catat detail kegagalan sistem pada file log utama aplikasi Anda
                Log::warning("Gagal mengirimkan notifikasi interaksi aktivitas: " . $e->getMessage());
            }

            $likesCount = Like::where('target_id', $model->id)
                            ->where('target_type', $modelClass)
                            ->count();

            return response()->json([
                'success' => true,
                'message' => ($request->target_type === 'post' ? 'Post' : 'Komentar') . ' berhasil di-like, bro!',
                'is_liked' => true,
                'likes_count' => $likesCount
            ], 201);
        }); 
    }
}
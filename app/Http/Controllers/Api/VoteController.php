<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Post;
use App\Models\Comment;
use App\Models\Vote;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class VoteController extends Controller
{
    public function handleVote(Request $request)
    {
        // 1. Validasi Input Data
        $validator = Validator::make($request->all(), [
            'target_id'   => 'required',
            'target_type' => 'required|in:post,comment',
            'vote_type'   => 'required|in:up,down'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors'  => $validator->errors()
            ], 422);
        }

        $user = auth('api')->user();

        // 2. Tentukan Model Target menggunakan Eager Loading 'user' agar relasinya pasti termuat
        if ($request->target_type === 'post') {
            $model = Post::with('user')->find($request->target_id);
            $modelName = Post::class;
        } else {
            $model = Comment::with('user')->find($request->target_id);
            $modelName = Comment::class;
        }

        if (!$model) {
            return response()->json([
                'success' => false, 
                'message' => 'Konten tidak ditemukan, bro.'
            ], 404);
        }

        // PERLINDUNGAN: Mencegah user melakukan vote pada konten miliknya sendiri
        if ($model->user_id === $user->id) {
            return response()->json([
                'success' => false,
                'message' => 'Kamu tidak bisa memberikan vote pada konten milikmu sendiri, bro!'
            ], 403);
        }

        // 3. Cek Riwayat Vote
        $existingVote = Vote::where('user_id', $user->id)
                            ->where('target_id', $model->id)
                            ->where('target_type', $modelName)
                            ->first();

        if ($existingVote) {
            // JIKA SAMA: Batal Vote (Toggle Off)
            if ($existingVote->vote_type === $request->vote_type) {
                $this->adjustScoreAndPoints($model, $existingVote->vote_type, 'cancel');
                $existingVote->delete();

                return response()->json([
                    'success' => true,
                    'message' => 'Vote kamu berhasil dibatalkan, bro!',
                    'vote_score' => $model->vote_score
                ], 200);
            }

            // JIKA BEDA: Ganti Pilihan Vote
            $this->adjustScoreAndPoints($model, $request->vote_type, 'switch');
            $existingVote->update(['vote_type' => $request->vote_type]);

            return response()->json([
                'success' => true,
                'message' => 'Vote kamu berhasil diubah, bro!',
                'vote_score' => $model->vote_score
            ], 200);
        }

      // 4. JIKA BELUM PERNAH VOTE: Buat data baru
        Vote::create([
            'user_id'     => $user->id,
            'target_id'   => $model->id,
            'target_type' => $modelName,
            'vote_type'   => $request->vote_type
        ]);

        $this->adjustScoreAndPoints($model, $request->vote_type, 'new');

        // REFRESH DATA MEMORI AGAR SINKRON DENGAN DATABASE FISIK
        $model->refresh(); 

        return response()->json([
            'success' => true,
            'message' => 'Vote berhasil dicatat, bro!',
            'vote_score' => $model->vote_score
        ], 201);
    }

    /**
     * FUNGSI PEMBANTU: Kalkulasi Skor Konten & Poin Reputasi
     */
    private function adjustScoreAndPoints($model, $voteType, $action)
    {
        // Menggunakan opsi alternatif relasi yang lebih aman dari crash memory
        $author = $model->user; 
        
        $scoreChange = ($voteType === 'up') ? 1 : -1;
        $pointChange = ($voteType === 'up') ? 5 : -2; 

        if ($action === 'cancel') {
            $model->decrement('vote_score', $scoreChange);
            // Pastikan model relasi author ditemukan sebelum memanggil fungsi increment/decrement
            if ($author && isset($author->points)) {
                $author->decrement('points', $pointChange);
            }
        } elseif ($action === 'switch') {
            $model->increment('vote_score', $scoreChange * 2);
            if ($author && isset($author->points)) {
                $author->increment('points', $pointChange * 2);
            }
        } else {
            $model->increment('vote_score', $scoreChange);
            if ($author && isset($author->points)) {
                $author->increment('points', $pointChange);
            }
        }
    }
}
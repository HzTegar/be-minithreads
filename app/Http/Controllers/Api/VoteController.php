<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Post;
use App\Models\Comment;
use App\Models\Vote;
use App\Services\ReputationService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;

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

        // 2. Tentukan Model Target
        if ($request->target_type === 'post') {
            $model = Post::with('user')->find($request->target_id);
        } else {
            $model = Comment::with('user')->find($request->target_id);
        }

        if (!$model) {
            return response()->json([
                'success' => false, 
                'message' => 'Konten tidak ditemukan, bro.'
            ], 404);
        }

        $modelClass = $model->getMorphClass();

        // PERLINDUNGAN: Mencegah user melakukan vote pada konten miliknya sendiri
        if ($model->user_id === $user->id) {
            return response()->json([
                'success' => false,
                'message' => 'Kamu tidak bisa memberikan vote pada konten milikmu sendiri, bro!'
            ], 403);
        }

        return DB::transaction(function () use ($request, $user, $model, $modelClass) {
            $service = app(ReputationService::class);
            $targetLabel = ($request->target_type === 'post') ? 'postingan' : 'komentar';

            // 3. Cek Riwayat Vote
            $existingVote = Vote::where('user_id', $user->id)
                                ->where('target_id', $model->id)
                                ->where('target_type', $modelClass)
                                ->first();

            if ($existingVote) {
                // JIKA SAMA: Batal Vote (Toggle Off)
                if ($existingVote->vote_type === $request->vote_type) {
                    $this->adjustScoreAndPoints($model, $user, $existingVote->vote_type, 'cancel', $service);
                    $existingVote->delete();

                    return response()->json([
                        'success' => true,
                        'message' => 'Vote kamu berhasil dibatalkan, bro!',
                        'vote_score' => $model->vote_score
                    ], 200);
                }

                // JIKA BEDA: Ganti Pilihan Vote
                $this->adjustScoreAndPoints($model, $user, $request->vote_type, 'switch', $service);
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
                'target_type' => $modelClass,
                'vote_type'   => $request->vote_type
            ]);

            $this->adjustScoreAndPoints($model, $user, $request->vote_type, 'new', $service);

            // Kirim Notifikasi jika UPVOTE pada POSTINGAN
            if ($request->vote_type === 'up' && $request->target_type === 'post') {
                $model->user->notify(new \App\Notifications\PostVotedNotification($model, $user));
            }

            // REFRESH DATA MEMORI AGAR SINKRON DENGAN DATABASE FISIK
            $model->refresh(); 

            return response()->json([
                'success' => true,
                'message' => 'Vote berhasil dicatat, bro!',
                'vote_score' => $model->vote_score
            ], 201);
        });
    }

    /**
     * FUNGSI PEMBANTU: Kalkulasi Skor Konten & Poin Reputasi
     */
    private function adjustScoreAndPoints($model, $voter, $voteType, $action, $service)
    {
        $scoreChange = ($voteType === 'up') ? 1 : -1;
        
        // Poin untuk VETER (yang melakukan voting)
        $points = ($voteType === 'up') ? ReputationService::POINTS_VOTE : ReputationService::POINTS_DOWNVOTE;
        $actionLabel = ($voteType === 'up') ? 'upvote' : 'downvote';
        $targetName = ($model instanceof Post) ? "post: {$model->title}" : "komentar";

        if ($action === 'cancel') {
            $model->decrement('vote_score', $scoreChange);
            
            // Kebalikan dari aksinya
            if ($voteType === 'up') {
                $service->deductPoints($voter, $points, "cancel_{$actionLabel}", $model->id, "Batal {$actionLabel} pada {$targetName}");
            } else {
                // Downvote yang dibatalkan -> kasih poin balik (deduct dari minus = add)
                $service->awardPoints($voter, $points, "cancel_{$actionLabel}", $model->id, "Batal {$actionLabel} pada {$targetName}");
            }
        } elseif ($action === 'switch') {
            $model->increment('vote_score', $scoreChange * 2);
            
            if ($voteType === 'up') {
                // Switch from Down to Up: +5 (remove downvote) +5 (add upvote) = +10
                $service->awardPoints($voter, ReputationService::POINTS_VOTE + ReputationService::POINTS_DOWNVOTE, "switch_to_{$actionLabel}", $model->id, "Ganti ke {$actionLabel} pada {$targetName}");
            } else {
                // Switch from Up to Down: -5 (remove upvote) -5 (add downvote) = -10
                $service->deductPoints($voter, ReputationService::POINTS_VOTE + ReputationService::POINTS_DOWNVOTE, "switch_to_{$actionLabel}", $model->id, "Ganti ke {$actionLabel} pada {$targetName}");
            }
        } else {
            $model->increment('vote_score', $scoreChange);
            
            if ($voteType === 'up') {
                $service->awardPoints($voter, $points, "new_{$actionLabel}", $model->id, "Memberikan {$actionLabel} pada {$targetName}");
            } else {
                $service->deductPoints($voter, $points, "new_{$actionLabel}", $model->id, "Memberikan {$actionLabel} pada {$targetName}");
            }
        }
    }
}
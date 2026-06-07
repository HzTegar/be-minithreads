<?php

namespace App\Services;

use App\Models\User;
use App\Models\PointsLog;
use Illuminate\Support\Facades\DB;

class ReputationService
{
    const MIN_POINTS_TO_POST = 20;
    const POINTS_LIKE = 10;
    const POINTS_VOTE = 5;
    const POINTS_DOWNVOTE = 5; // Will be used for deduction
    const POINTS_ACCEPTED_ANSWER = 15;

    /**
     * Berikan poin reputasi ke user.
     */
    public function awardPoints(User $user, int $points, string $actionType, string $referenceId = null, string $description = null)
    {
        return DB::transaction(function () use ($user, $points, $actionType, $referenceId, $description) {
            // Update total poin di tabel users
            $user->increment('reputation_points', $points);

            // Catat log
            return PointsLog::create([
                'user_id' => $user->id,
                'points' => $points,
                'action_type' => $actionType,
                'reference_id' => $referenceId,
                'description' => $description,
            ]);
        });
    }

    /**
     * Kurangi poin reputasi user (misal saat status accepted dicabut).
     */
    public function deductPoints(User $user, int $points, string $actionType, string $referenceId = null, string $description = null)
    {
        return DB::transaction(function () use ($user, $points, $actionType, $referenceId, $description) {
            $user->decrement('reputation_points', $points);

            return PointsLog::create([
                'user_id' => $user->id,
                'points' => -$points,
                'action_type' => $actionType,
                'reference_id' => $referenceId,
                'description' => $description,
            ]);
        });
    }
}

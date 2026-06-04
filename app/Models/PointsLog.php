<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class PointsLog extends Model
{
    /** @use HasFactory<\Database\Factories\PointsLogFactory> */
    use HasFactory, HasUuids;

    protected $fillable = [
        'user_id',
        'points',
        'action_type',
        'reference_id',
        'description',
    ];

    protected $casts = [
        'points' => 'integer',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}

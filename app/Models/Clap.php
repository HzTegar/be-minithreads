<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\MorphTo;

class Clap extends Model
{
    use HasFactory, HasUuids;

    protected $fillable = [
        'user_id',
        'clapable_id',
        'clapable_type',
        'count',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function clapable(): MorphTo
    {
        return $this->morphTo();
    }
}

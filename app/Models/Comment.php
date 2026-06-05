<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\MorphMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class Comment extends Model
{
    /** @use HasFactory<\Database\Factories\CommentFactory> */
    use HasFactory, HasUuids;
    use SoftDeletes;

    protected $fillable = [
        'post_id',
        'user_id',
        'parent_id',
        'body',
        'vote_score',
        'is_accepted',
        'is_edited',
    ];

    protected $casts = [
        'vote_score' => 'integer',
        'is_accepted' => 'boolean',
        'is_edited' => 'boolean',
    ];

    public function post(): BelongsTo
    {
        return $this->belongsTo(Post::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function editHistories(): HasMany
    {
        return $this->hasMany(CommentEditHistory::class);
    }

    public function parent(): BelongsTo
    {
        return $this->belongsTo(Comment::class, 'parent_id');
    }

    public function replies(): HasMany
    {
        return $this->hasMany(Comment::class, 'parent_id');
    }

    public function votes(): MorphMany
    {
        return $this->morphMany(Vote::class, 'target');
    }

    public function likes(): MorphMany
    {
        return $this->morphMany(Like::class, 'target');
    }

    public function claps(): MorphMany
    {
        return $this->morphMany(Clap::class, 'clapable');
    }
}

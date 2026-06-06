<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\MorphMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use App\Models\CommentEditHistory;

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

    protected $appends = ['status', 'is_liked'];

    public function getIsLikedAttribute(): bool
    {
        $user = auth('api')->user();
        if (!$user) return false;
        return $this->likes()->where('user_id', $user->id)->exists();
    }

    public function getStatusAttribute(): ?string
    {
        return $this->is_edited ? 'edited' : null;
    }

    public function post(): BelongsTo
    {
        return $this->belongsTo(Post::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function edit_histories(): HasMany
    {
        return $this->hasMany(CommentEditHistory::class, 'comment_id');
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

    public function reports(): MorphMany
    {
        return $this->morphMany(Report::class, 'target');
    }

    public function claps(): MorphMany
    {
        return $this->morphMany(Clap::class, 'clapable');
    }

    
}

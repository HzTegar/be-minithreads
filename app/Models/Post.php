<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\MorphMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class Post extends Model
{
    /** @use HasFactory<\Database\Factories\PostFactory> */
    use HasFactory, HasUuids;
    use SoftDeletes;

    protected $fillable = [
        'user_id',
        'category_id',
        'title',
        'slug',
        'body',
        'status',
        'published_at',
        'view_count',
        'vote_score',
        'is_answered',
        'accepted_answer_id',
        'edit_count',
    ];

    protected $casts = [
        'view_count' => 'integer',
        'vote_score' => 'integer',
        'is_answered' => 'boolean',
        'published_at' => 'datetime',
        'edit_count' => 'integer',
    ];

    protected static function booted()
{
    static::deleting(function ($post) {
        // Jika postingan di-delete (soft delete), otomatis soft delete semua komentar yang ada di postingan ini
        $post->comments()->delete();
    });
}

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }

    public function comments(): HasMany
    {
        return $this->hasMany(Comment::class);
    }

    public function editHistories(): HasMany
    {
        return $this->hasMany(PostEditHistory::class);
    }

    /**
     * RELASI MANY-TO-MANY (SUDAH DIPERBAIKI KOCOK KUNCI UUID)
     * Parameter 3: 'post_id' (kolom milik tabel posts di tabel pivot)
     * Parameter 4: 'tag_id' (kolom milik tabel tags di tabel pivot)
     */
    public function tags(): BelongsToMany
    {
        return $this->belongsToMany(Tag::class, 'post_tags', 'post_id', 'tag_id');
    }

    public function acceptedAnswer(): BelongsTo
    {
        return $this->belongsTo(Comment::class, 'accepted_answer_id');
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

    public function bookmarks(): HasMany
    {
        return $this->hasMany(Bookmark::class);
    }
}
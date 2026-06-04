<?php

namespace App\Models;

use Database\Factories\UserFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Tymon\JWTAuth\Contracts\JWTSubject;

class User extends Authenticatable implements JWTSubject
{
    use HasFactory, Notifiable, HasUuids;

    protected $fillable = [
        'username',
        'email',
        'password_hash',
        'avatar_url',
        'bio',
        'reputation_points',
        'level', // Kolom level tetap ada
    ];

    protected $hidden = [
        'password_hash',
        'remember_token',
    ];

    public function getAuthPassword()
    {
        return $this->password_hash;
    }

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password_hash' => 'hashed',
            'reputation_points' => 'integer',
        ];
    }

    /**
     * JWT SUBJECT METHODS
     */
    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    public function getJWTCustomClaims()
{
    return [
        'level' => $this->level // Pastikan key-nya 'level'
    ];
}

    /**
     * HELPER METHODS UNTUK CEK LEVEL
     */
    public function isAdmin(): bool
    {
        return $this->level === 'admin';
    }

    public function isModerator(): bool
    {
        return $this->level === 'moderator';
    }

    /**
     * Mengecek apakah user memiliki level tertentu.
     * @param string|array $roleName
     * @return bool
     */
    public function hasRole($roleName): bool
    {
        if (is_array($roleName)) {
            return in_array($this->level, $roleName);
        }

        return $this->level === $roleName;
    }

    /**
     * RELATIONS (FITUR FOLLOW DAN LAINNYA TETAP ADA)
     */
    public function posts(): HasMany
    {
        return $this->hasMany(Post::class);
    }

    public function comments(): HasMany
    {
        return $this->hasMany(Comment::class);
    }

    public function votes(): HasMany
    {
        return $this->hasMany(Vote::class);
    }

    public function likes(): HasMany
    {
        return $this->hasMany(Like::class);
    }

    // Fungsi Follow tetap dipertahankan
    public function followers(): BelongsToMany
    {
        return $this->belongsToMany(User::class, 'follows', 'following_id', 'follower_id')->withTimestamps();
    }

    public function followings(): BelongsToMany
    {
        return $this->belongsToMany(User::class, 'follows', 'follower_id', 'following_id')->withTimestamps();
    }

    public function pointsLogs(): HasMany
    {
        return $this->hasMany(PointsLog::class);
    }

    public function bookmarks(): HasMany
    {
        return $this->hasMany(Bookmark::class);
    }

    public function claps(): HasMany
    {
        return $this->hasMany(Clap::class);
    }
}
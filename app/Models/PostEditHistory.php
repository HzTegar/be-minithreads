<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class PostEditHistory extends Model
{
    use HasFactory, HasUuids;

    // Tambahkan properti table untuk memastikan nama tabelnya pas
    protected $table = 'post_edit_histories';

    protected $fillable = [
        'post_id',
        'user_id', 
        'old_title',
        'new_title',
        'old_body',
        'new_body',
        'edit_number',
    ];

    // TAMBAHKAN INI: Relasi ke model User (Siapa yang mengedit postingan)
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function post(): BelongsTo
    {
        return $this->belongsTo(Post::class, 'post_id');
    }
}
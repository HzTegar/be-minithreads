<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class PostEditHistory extends Model
{
    use HasFactory, HasUuids;

    protected $fillable = [
        'post_id',
        'old_title',
        'new_title',
        'old_body',
        'new_body',
        'edit_number',
    ];

    public function post(): BelongsTo
    {
        return $this->belongsTo(Post::class);
    }
}

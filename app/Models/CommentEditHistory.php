<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class CommentEditHistory extends Model
{
    use HasFactory, HasUuids;

    protected $fillable = [
        'comment_id',
        'old_body',
        'new_body',
    ];

    public function comment(): BelongsTo
    {
        return $this->belongsTo(Comment::class);
    }
}

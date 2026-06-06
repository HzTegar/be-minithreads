<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class CommentEditHistory extends Model
{
    use HasFactory;

    protected $keyType = 'string';
    public $incrementing = false;

    // Kolom yang wajib diizinkan untuk diisi massal
    protected $fillable = [
        'comment_id',
        'user_id',
        'old_content',
        'new_content',
        'edit_number',
    ];

    protected static function boot()
    {
        parent::boot();
        // Membuat UUID otomatis saat data riwayat baru dibuat
        static::creating(function ($model) {
            if (empty($model->{$model->getKeyName()})) {
                $model->{$model->getKeyName()} = (string) Str::uuid();
            }
        });
    }

    // Relasi balik ke komentar utama
    public function comment()
    {
        return $this->belongsTo(Comment::class, 'comment_id');
    }

    // Relasi untuk melihat siapa staf/user yang mengedit
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}
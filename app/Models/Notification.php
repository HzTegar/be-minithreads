<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Notification extends Model
{
    use HasFactory;

    // Menentukan nama tabel (opsional, jika nama tabel Anda 'notifications')
    protected $table = 'notifications';

    /**
     * Kolom yang dapat diisi secara massal (mass assignable).
     */
    protected $fillable = [
        'user_id',
        'title',
        'message',
        'type',
        'is_read'
    ];

    /**
     * Cast atribut ke tipe data tertentu.
     */
    protected $casts = [
        'is_read' => 'boolean',
    ];

    /**
     * Relasi balik ke Model User (Pemilik Notifikasi).
     */
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}
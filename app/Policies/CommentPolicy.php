<?php

namespace App\Policies;

use App\Models\Comment;
use App\Models\User;

class CommentPolicy
{
    /**
     * Aturan Edit: Hanya pemilik komentar yang bisa mengedit
     */
    public function update(User $user, Comment $comment): bool
    {
        return $user->id === $comment->user_id;
    }

    /**
     * Aturan Hapus: Hanya Admin dan Moderator yang bisa menghapus komentar
     */
    public function delete(User $user, Comment $comment): bool
    {
        // Menyesuaikan dengan sistem multi-role yang sudah kamu buat di Fitur 2
        return in_array($user->role, ['admin', 'moderator']);
    }
}
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Post;
use Illuminate\Http\Request;

class BookmarkController extends Controller
{
    /**
     * 1. MENAMPILKAN DAFTAR BOOKMARK USER
     * GET /api/bookmarks
     */
    public function index()
    {
        $user = auth('api')->user();

        // Mengambil postingan yang dibookmark user, lengkap dengan data pembuat post (user) dan kategori
        $bookmarks = $user->bookmarkedPosts()
            ->with(['user', 'category'])
            ->latest('bookmarks.created_at')
            ->paginate(10);

        return response()->json([
            'success' => true,
            'message' => 'Daftar bookmark kamu berhasil diambil, bro!',
            'data'    => $bookmarks
        ], 200);
    }

    /**
     * 2. TOGGLE BOOKMARK (SIMPAN / BATALKAN)
     * POST /api/posts/{postId}/bookmark
     */
    public function toggle($postId)
    {
        // Pastikan postingan yang mau dibookmark memang ada di DB
        $post = Post::find($postId);

        if (!$post) {
            return response()->json([
                'success' => false,
                'message' => 'Postingan tidak ditemukan.'
            ], 404);
        }

        $user = auth('api')->user();

        // Menggunakan fungsi toggle() bawaan Laravel Eloquent.
        // Jika belum ada di tabel pivot -> akan disimpan (attach).
        // Jika sudah ada di tabel pivot -> akan dihapus (detach).
        $result = $user->bookmarkedPosts()->toggle($post->id);

        // Mengecek apakah aksinya tadi itu memasukkan atau menghapus data
        $isBookmarked = count($result['attached']) > 0;

        return response()->json([
            'success' => true,
            'message' => $isBookmarked 
                ? 'Postingan berhasil disimpan ke daftar bookmark, bro!' 
                : 'Postingan berhasil dihapus dari daftar bookmark!',
            'is_bookmarked' => $isBookmarked
        ], 200);
    }
}
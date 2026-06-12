<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Post;
use App\Models\Bookmark;
use Illuminate\Http\Request;

class BookmarkController extends Controller
{
    /**
     * 1. MENAMPILKAN DAFTAR BOOKMARK USER
     */
    public function index(Request $request)
    {
        $user = auth('api')->user();

        // Mengambil data dari tabel bookmarks milik user ini, langsung ditarik data postingannya
        $query = Bookmark::where('user_id', $user->id)
            ->with(['post.user', 'post.category']) // Load data post beserta penulis dan kategorinya
            ->latest();

        if ($request->has('keyword')) {
            $keyword = $request->keyword;
            $query->whereHas('post', function ($q) use ($keyword) {
                $q->where('title', 'LIKE', "%{$keyword}%")
                  ->orWhere('body', 'LIKE', "%{$keyword}%");
            });
        }

        $bookmarks = $query->paginate(10);

        return response()->json([
            'success' => true,
            'message' => 'Daftar bookmark kamu berhasil diambil, bro!',
            'data'    => $bookmarks
        ], 200);
    }

    /**
     * 2. TOGGLE BOOKMARK (SIMPAN / BATALKAN)
     */
    public function toggle($postId)
    {
        // 1. Pastikan postingan ada di database
        $post = Post::find($postId);

        if (!$post) {
            return response()->json([
                'success' => false,
                'message' => 'Postingan tidak ditemukan.'
            ], 404);
        }

        $user = auth('api')->user();

        // 2. Cek apakah user sudah pernah membookmark postingan ini
        $bookmark = Bookmark::where('user_id', $user->id)
            ->where('post_id', $post->id)
            ->first();

        if ($bookmark) {
            // Jika sudah ada -> Hapus (Unbookmark)
            $bookmark->delete();

            return response()->json([
                'success' => true,
                'message' => 'Postingan berhasil dihapus dari daftar bookmark!',
                'is_bookmarked' => false
            ], 200);
        } else {
            // Jika belum ada -> Buat Baru (Bookmark)
            Bookmark::create([
                'user_id' => $user->id,
                'post_id' => $post->id
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Postingan berhasil disimpan ke daftar bookmark, bro!',
                'is_bookmarked' => true
            ], 200);
        }
    }
}
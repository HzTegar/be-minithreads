<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Post;
use App\Models\User;
use App\Models\Tag;
use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class SearchController extends Controller
{
    /**
     * 1. SEARCH POSTS (Pencarian khusus Postingan)
     * Mencari berdasarkan judul, isi, kategori, atau tag.
     * Mendukung pencarian instan sejak karakter pertama (1 huruf).
     */
    public function searchPosts(Request $request)
    {
        $keyword = $request->query('keyword');

        // Diubah menjadi < 1 agar ketik 1 huruf langsung memunculkan data, bro
        if (!$keyword || strlen($keyword) < 1) {
            return response()->json([
                'success' => false,
                'message' => 'Keyword tidak boleh kosong, bro.'
            ], 422);
        }

        $posts = Post::with(['user', 'category', 'tags', 'comments.user'])
            ->where(function ($query) use ($keyword) {
                $query->where('title', 'LIKE', "%{$keyword}%")
                      ->orWhere('body', 'LIKE', "%{$keyword}%")
                      ->orWhereHas('category', function ($q) use ($keyword) {
                          $q->where('name', 'LIKE', "%{$keyword}%");
                      })
                      ->orWhereHas('tags', function ($q) use ($keyword) {
                          $q->where('name', 'LIKE', "%{$keyword}%");
                      });
            })
            ->latest()
            ->paginate(10);

        return response()->json([
            'success' => true,
            'message' => "Hasil pencarian postingan untuk keyword: '$keyword'",
            'data' => $posts
        ], 200);
    }

    /**
     * 2. SEARCH USERS (Pencarian khusus User)
     * Mencari berdasarkan username atau bio.
     * Mendukung pencarian instan sejak karakter pertama (1 huruf).
     */
    public function searchUsers(Request $request)
    {
        $keyword = $request->query('keyword');

        // Diubah menjadi < 1 agar ketik 1 huruf langsung memunculkan data, bro
        if (!$keyword || strlen($keyword) < 1) {
            return response()->json([
                'success' => false,
                'message' => 'Keyword tidak boleh kosong, bro.'
            ], 422);
        }

        $users = User::where('username', 'LIKE', "%{$keyword}%")
            ->orWhere('bio', 'LIKE', "%{$keyword}%")
            ->paginate(10);

        return response()->json([
            'success' => true,
            'message' => "Hasil pencarian user untuk keyword: '$keyword'",
            'data' => $users
        ], 200);
    }

    /**
     * 3. SEARCH TAGS (Pencarian khusus Tag)
     * Mendukung pencarian instan sejak karakter pertama (1 huruf).
     */
    public function searchTags(Request $request)
    {
        $keyword = $request->query('keyword');

        // Diubah menjadi < 1 agar ketik 1 huruf langsung memunculkan data, bro
        if (!$keyword || strlen($keyword) < 1) {
            return response()->json([
                'success' => false,
                'message' => 'Keyword tidak boleh kosong, bro.'
            ], 422);
        }

        $tags = Tag::where('name', 'LIKE', "%{$keyword}%")
            ->paginate(10);

        return response()->json([
            'success' => true,
            'message' => "Hasil pencarian tag untuk keyword: '$keyword'",
            'data' => $tags
        ], 200);
    }

    /**
     * 4. SEARCH CATEGORIES (Pencarian khusus Kategori)
     * Mendukung pencarian instan sejak karakter pertama (1 huruf).
     */
    public function searchCategories(Request $request)
    {
        $keyword = $request->query('keyword');

        // Diubah menjadi < 1 agar ketik 1 huruf langsung memunculkan data, bro
        if (!$keyword || strlen($keyword) < 1) {
            return response()->json([
                'success' => false,
                'message' => 'Keyword tidak boleh kosong, bro.'
            ], 422);
        }

        $categories = Category::where('name', 'LIKE', "%{$keyword}%")
            ->paginate(10);

        return response()->json([
            'success' => true,
            'message' => "Hasil pencarian kategori untuk keyword: '$keyword'",
            'data' => $categories
        ], 200);
    }

    /**
     * 5. SEARCH COMMENTS (Pencarian khusus Komentar)
     * Mendukung pencarian instan sejak karakter pertama (1 huruf).
     */
    public function searchComments(Request $request)
    {
        $keyword = $request->query('keyword');

        if (!$keyword || strlen($keyword) < 1) {
            return response()->json([
                'success' => false,
                'message' => 'Keyword tidak boleh kosong, bro.'
            ], 422);
        }

        $comments = \App\Models\Comment::with(['user', 'post'])
            ->where('body', 'LIKE', "%{$keyword}%")
            ->latest()
            ->paginate(10);

        return response()->json([
            'success' => true,
            'message' => "Hasil pencarian komentar untuk keyword: '$keyword'",
            'data' => $comments
        ], 200);
    }

    /**
     * 6. GLOBAL SEARCH
     * Mencari di semua entitas dan mengembalikan hasil gabungan.
     * Mendukung pencarian instan sejak karakter pertama (1 huruf).
     */
    public function searchGlobal(Request $request)
    {
        $keyword = $request->query('keyword');

        // Diubah menjadi < 1 agar ketik 1 huruf langsung memunculkan data, bro
        if (!$keyword || strlen($keyword) < 1) {
            return response()->json([
                'success' => false,
                'message' => 'Keyword tidak boleh kosong, bro.'
            ], 422);
        }

        // Ambil data postingan (Sesuai permintaan: include category, tags, comments, user)
        $posts = Post::with(['user', 'category', 'tags', 'comments.user'])
            ->where(function ($query) use ($keyword) {
                $query->where('title', 'LIKE', "%{$keyword}%")
                      ->orWhere('body', 'LIKE', "%{$keyword}%")
                      ->orWhereHas('category', function ($q) use ($keyword) {
                          $q->where('name', 'LIKE', "%{$keyword}%");
                      })
                      ->orWhereHas('tags', function ($q) use ($keyword) {
                          $q->where('name', 'LIKE', "%{$keyword}%");
                      });
            })
            ->latest()
            ->limit(5)
            ->get();

        // Ambil data user
        $users = User::where('username', 'LIKE', "%{$keyword}%")
            ->limit(5)
            ->get();

        // Ambil data tag
        $tags = Tag::where('name', 'LIKE', "%{$keyword}%")
            ->limit(5)
            ->get();

        // ambil data kategori
        $categories = Category::where('name', 'LIKE', "%{$keyword}%")
            ->limit(5)
            ->get();

        // Ambil data komentar
        $comments = \App\Models\Comment::with(['user', 'post'])
            ->where('body', 'LIKE', "%{$keyword}%")
            ->latest()
            ->limit(5)
            ->get();

        return response()->json([
            'success' => true,
            'message' => "Hasil pencarian global untuk keyword: '$keyword'",
            'data' => [
                'posts'      => $posts,
                'users'      => $users,
                'tags'       => $tags,
                'categories' => $categories,
                'comments'   => $comments
            ]
        ], 200);
    }
}
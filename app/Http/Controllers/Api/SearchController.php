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
     */
    public function searchPosts(Request $request)
    {
        $keyword = $request->query('keyword');

        if (!$keyword || strlen($keyword) < 2) {
            return response()->json([
                'success' => false,
                'message' => 'Keyword minimal 2 karakter, bro.'
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
     */
    public function searchUsers(Request $request)
    {
        $keyword = $request->query('keyword');

        if (!$keyword || strlen($keyword) < 2) {
            return response()->json([
                'success' => false,
                'message' => 'Keyword minimal 2 karakter, bro.'
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
     */
    public function searchTags(Request $request)
    {
        $keyword = $request->query('keyword');

        if (!$keyword || strlen($keyword) < 2) {
            return response()->json([
                'success' => false,
                'message' => 'Keyword minimal 2 karakter, bro.'
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
     */
    public function searchCategories(Request $request)
    {
        $keyword = $request->query('keyword');

        if (!$keyword || strlen($keyword) < 2) {
            return response()->json([
                'success' => false,
                'message' => 'Keyword minimal 2 karakter, bro.'
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
     * 5. GLOBAL SEARCH
     * Mencari di semua entitas dan mengembalikan hasil gabungan.
     */
    public function searchGlobal(Request $request)
    {
        $keyword = $request->query('keyword');

        if (!$keyword || strlen($keyword) < 2) {
            return response()->json([
                'success' => false,
                'message' => 'Keyword minimal 2 karakter, bro.'
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

        // Ambil data kategori
        $categories = Category::where('name', 'LIKE', "%{$keyword}%")
            ->limit(5)
            ->get();

        return response()->json([
            'success' => true,
            'message' => "Hasil pencarian global untuk keyword: '$keyword'",
            'data' => [
                'posts'      => $posts,
                'users'      => $users,
                'tags'       => $tags,
                'categories' => $categories
            ]
        ], 200);
    }
}

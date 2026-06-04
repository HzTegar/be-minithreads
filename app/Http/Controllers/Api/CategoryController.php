<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

class CategoryController extends Controller
{
    /**
     * 1. AMBIL SEMUA KATEGORI (INDEX)
     * Publik: Bisa diakses oleh User, Moderator, dan Admin
     */
    public function index()
    {
        $categories = Category::withCount('posts')->latest()->get();

        return response()->json([
            'success' => true,
            'message' => 'Daftar semua kategori berhasil diambil, bro!',
            'data'    => $categories
        ], 200);
    }

    /**
     * 2. BUAT KATEGORI BARU (STORE)
     * Privat: Hanya bisa diakses oleh ADMIN dan MODERATOR
     */
    public function store(Request $request)
    {
        try {
            $user = auth('api')->user();
            
            // BATESAN: Hanya Admin dan Moderator yang boleh lewat (User biasa ditolak)
            if (!$user || (!$user->isAdmin() && $user->level !== 'moderator')) {
                return response()->json([
                    'success' => false,
                    'message' => 'Akses ditolak! Fitur ini hanya untuk Admin atau Moderator, bro.'
                ], 403);
            }

            $validator = Validator::make($request->all(), [
                'name'        => 'required|string|max:100|unique:categories,name',
                'description' => 'nullable|string|max:255',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'errors'  => $validator->errors()
                ], 422);
            }

            $category = Category::create([
                'name'        => $request->name,
                'slug'        => Str::slug($request->name),
                'description' => $request->description,
            ]);

            $category->posts_count = 0;

            return response()->json([
                'success' => true,
                'message' => 'Kategori baru berhasil dibuat, bro!',
                'data'    => $category
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan pada server.',
                'error'   => $e->getMessage()
            ], 500);
        }
    }

    /**
     * 3. DETAIL SATU KATEGORI (SHOW)
     * Publik: Bisa diakses oleh User, Moderator, dan Admin
     */
    public function show($id)
    {
        $category = Category::withCount('posts')->find($id);

        if (!$category) {
            return response()->json([
                'success' => false,
                'message' => 'Kategori tidak ditemukan.'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'Detail kategori berhasil ditemukan, bro!',
            'data'    => $category
        ], 200);
    }

    /**
     * 4. EDIT KATEGORI (UPDATE)
     * Privat: Hanya bisa diakses oleh ADMIN dan MODERATOR
     */
    public function update(Request $request, $id)
    {
        try {
            $user = auth('api')->user();
            
            // BATESAN: Hanya Admin dan Moderator yang boleh edit (User biasa ditolak)
            if (!$user || (!$user->isAdmin() && $user->level !== 'moderator')) {
                return response()->json([
                    'success' => false,
                    'message' => 'Akses ditolak! Fitur ini hanya untuk Admin atau Moderator, bro.'
                ], 403);
            }

            $category = Category::find($id);
            if (!$category) {
                return response()->json([
                    'success' => false,
                    'message' => 'Kategori tidak ditemukan.'
                ], 404);
            }

            $validator = Validator::make($request->all(), [
                'name'        => 'required|string|max:100|unique:categories,name,' . $id,
                'description' => 'nullable|string|max:255',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'errors'  => $validator->errors()
                ], 422);
            }

            $category->update([
                'name'        => $request->name,
                'slug'        => Str::slug($request->name),
                'description' => $request->description ?? $category->description,
            ]);

            $category = Category::withCount('posts')->find($id);

            return response()->json([
                'success' => true,
                'message' => 'Kategori berhasil diperbarui, bro!',
                'data'    => $category
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan pada server.',
                'error'   => $e->getMessage()
            ], 500);
        }
    }

    /**
     * 5. HAPUS KATEGORI (DESTROY)
     * Privat Keras: HANYA BOLEH ADMIN (Moderator dan User biasa ditolak)
     */
    public function destroy($id)
    {
        try {
            $user = auth('api')->user();
            
            // BATESAN KERAS: Moderator sekalipun akan ditolak di sini jika mencoba menghapus
            if (!$user || !$user->isAdmin()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Akses ditolak! Hanya Admin utama yang boleh menghapus kategori, bro.'
                ], 403);
            }

            $category = Category::find($id);
            if (!$category) {
                return response()->json([
                    'success' => false,
                    'message' => 'Kategori tidak ditemukan.'
                ], 404);
            }

            $category->delete();

            return response()->json([
                'success' => true,
                'message' => 'Kategori berhasil dihapus secara permanen oleh Admin, bro!'
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan pada server.',
                'error'   => $e->getMessage()
            ], 500);
        }
    }
}
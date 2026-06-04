<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Tag;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

class TagController extends Controller
{
    /**
     * 1. AMBIL SEMUA TAG (INDEX)
     */
    public function index()
    {
        $tags = Tag::withCount('posts')->latest()->get();

        return response()->json([
            'success' => true,
            'message' => 'Daftar semua tag berhasil diambil, bro!',
            'data'    => $tags
        ], 200);
    }

    /**
     * 2. BUAT TAG BARU (STORE)
     */
    public function store(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'name'  => 'required|string|max:100|unique:tags,name',
                'color' => 'nullable|string|max:7|regex:/^#([A-Fa-f0-9]{6})$/',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'errors'  => $validator->errors()
                ], 422);
            }

            $tag = Tag::create([
                'name'  => $request->name,
                'slug'  => Str::slug($request->name),
                'color' => $request->color ?? '#3B82F6',
            ]);

            $tag->posts_count = 0;

            return response()->json([
                'success' => true,
                'message' => 'Tag baru berhasil dibuat, bro!',
                'data'    => $tag
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
     * 3. DETAIL SATU TAG (SHOW)
     */
    public function show($id)
    {
        $tag = Tag::withCount('posts')->find($id);

        if (!$tag) {
            return response()->json([
                'success' => false,
                'message' => 'Tag tidak ditemukan.'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'Detail tag berhasil ditemukan, bro!',
            'data'    => $tag
        ], 200);
    }

    /**
     * 4. EDIT TAG (UPDATE) - KHUSUS ADMIN
     */
    public function update(Request $request, $id)
    {
        try {
            $user = auth('api')->user();
            
            // PERBAIKAN: Menggunakan helper isAdmin()
            if (!$user || !$user->isAdmin()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Akses ditolak! Fitur ini hanya untuk Admin, bro.'
                ], 403);
            }

            $tag = Tag::find($id);
            if (!$tag) {
                return response()->json([
                    'success' => false,
                    'message' => 'Tag tidak ditemukan.'
                ], 404);
            }

            $validator = Validator::make($request->all(), [
                'name'  => 'required|string|max:100|unique:tags,name,' . $id,
                'color' => 'nullable|string|max:7|regex:/^#([A-Fa-f0-9]{6})$/',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'errors'  => $validator->errors()
                ], 422);
            }

            $tag->update([
                'name'  => $request->name,
                'slug'  => Str::slug($request->name),
                'color' => $request->color ?? $tag->color,
            ]);

            $tag = Tag::withCount('posts')->find($id);

            return response()->json([
                'success' => true,
                'message' => 'Tag berhasil diperbarui oleh Admin, bro!',
                'data'    => $tag
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
     * 5. HAPUS TAG (DESTROY) - KHUSUS ADMIN
     */
    public function destroy($id)
    {
        try {
            $user = auth('api')->user();
            
            // PERBAIKAN: Menggunakan helper isAdmin()
            if (!$user || !$user->isAdmin()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Akses ditolak! Fitur ini hanya untuk Admin, bro.'
                ], 403);
            }

            $tag = Tag::find($id);
            if (!$tag) {
                return response()->json([
                    'success' => false,
                    'message' => 'Tag tidak ditemukan.'
                ], 404);
            }

            $tag->posts()->detach();
            $tag->delete();

            return response()->json([
                'success' => true,
                'message' => 'Tag dan semua relasi postingannya berhasil dihapus oleh Admin, bro!'
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
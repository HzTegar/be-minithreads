<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ProfileController extends Controller
{
    public function updateProfile(Request $request)
    {
        // 1. Ambil data user yang sedang login
        $user = auth('api')->user();

        // 2. Validasi inputan
        $validator = Validator::make($request->all(), [
            'bio' => 'nullable|string|max:500',
            'avatar' => 'nullable|image|mimes:jpeg,png,jpg|max:2048', // Maksimal 2MB
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        // 3. Logika jika user mengunggah foto avatar baru
        if ($request->hasFile('avatar')) {
            $file = $request->file('avatar');
            // Menyimpan file ke folder public/storage/avatars
            $path = $file->store('avatars', 'public'); 

            // Masukkan alamat URL gambar ke kolom avatar_url
            $user->avatar_url = asset('storage/' . $path);
        }

        // 4. Update data bio jika diisi
        if ($request->has('bio')) {
            $user->bio = $request->bio;
        }

        // 5. Simpan perubahan ke database
        $user->save();

        return response()->json([
            'success' => true,
            'message' => 'Profil kamu berhasil diperbarui, bro!',
            'user' => $user
        ]);
    }
}
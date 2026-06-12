<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class ProfileController extends Controller
{
    public function updateProfile(Request $request)
    {
        // 1. Ambil data user yang sedang login via API
        $user = auth('api')->user();

        // 2. Validasi inputan khusus untuk bio, avatar, username, dan password
        $validator = Validator::make($request->all(), [
            'bio'      => 'nullable|string|max:500',
            'avatar'   => 'nullable|image|mimes:jpeg,png,jpg|max:2048', // Maksimal 2MB
            'username' => [
                'nullable',
                'string',
                'max:50',
                Rule::unique('users', 'username')->ignore($user->id) // Unik kecuali milik sendiri
            ],
            'password' => 'nullable|string|min:8', // Opsional, minimal 8 karakter, tanpa confirm_password
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors'  => $validator->errors()
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

        // 5. Update data username jika diisi
        if ($request->filled('username')) {
            $user->username = $request->username;
        }

        // 6. Update data password jika diisi (Otomatis di-bcrypt ke kolom password_hash)
        if ($request->filled('password')) {
            $user->password_hash = bcrypt($request->password);
        }

        // 7. Simpan seluruh perubahan data ke database
        $user->save();

        return response()->json([
            'success' => true,
            'message' => 'Profil kamu berhasil diperbarui, bro!',
            'user'    => $user
        ]);
    }
}
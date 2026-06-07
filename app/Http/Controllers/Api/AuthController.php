<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class AuthController extends Controller
{
    /**
     * LOGIKA REGISTER
     */
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'username' => 'required|string|max:255|unique:users',
            'email'    => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:6|confirmed',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $user = User::create([
            'id'            => Str::uuid(),
            'username'      => $request->username,
            'email'         => $request->email,
            'password_hash' => $request->password,
            'reputation_points' => 0,
            'level'         => 'user', 
        ]);

        return response()->json([
            'success' => true,
            'message' => 'User berhasil didaftarkan sebagai member!',
            'user'    => $user
        ], 201);
    }

    /**
     * LOGIKA LOGIN
     */
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email'    => 'required|email',
            'password' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password_hash)) {
            return response()->json([
                'success' => false,
                'message' => 'Email atau password salah, bro!'
            ], 401);
        }

        $token = auth('api')->login($user);

        return $this->respondWithToken($token);
    }

    /**
     * DASHBOARD ADMIN
     * Hanya bisa diakses oleh user dengan level 'admin'
     */
    public function dashboard()
    {
        $user = User::find(auth('api')->user()->id);

        // Pengecekan akses: Admin DAN Moderator boleh masuk
        if (!$user || !in_array($user->level, ['admin', 'moderator'])) {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak! Hanya Admin atau Moderator yang boleh masuk.'
            ], 403);
        }

        return response()->json([
            'success' => true,
            'message' => 'Selamat datang di Dashboard ' . ucfirst($user->level) . '!',
            'data' => [
                'username' => $user->username,
                'level'    => $user->level,
                'status'   => 'Authorized Access'
            ]
        ]);
    }

    /**
     * LOGIKA ME (Melihat Profil Sendiri)
     */
    public function me()
    {
        return response()->json([
            'success' => true,
            'user'    => auth('api')->user()
        ]);
    }

    /**
     * LOGIKA LOGOUT
     */
    public function logout()
    {
        auth('api')->logout();
        return response()->json(['success' => true, 'message' => 'Berhasil logout, token hangus!']);
    }

    protected function respondWithToken($token)
    {
        return response()->json([
            'success' => true,
            'access_token' => $token,
            'token_type'   => 'bearer',
            'expires_in'   => auth('api')->factory()->getTTL() * 60,
            'user'         => auth('api')->user()
        ]);
    }
}
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Post;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ProfileController extends Controller
{
    /**
     * PUBLIC: Lihat profil user berdasarkan username
     * GET /api/users/{username}
     */
    public function show($username)
    {
        $user = User::where('username', $username)->first();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'User tidak ditemukan.'
            ], 404);
        }

        $threads = Post::with(['category', 'tags'])
            ->withCount(['comments', 'likes'])
            ->where('user_id', $user->id)
            ->whereIn('status', ['open', 'closed'])
            ->latest()
            ->get();

        // Cek apakah user yang sedang login sudah follow user ini
        $authUser = auth('api')->user();
        $isFollowing = $authUser
            ? $authUser->followings()->where('following_id', $user->id)->exists()
            : false;

        return response()->json([
            'success' => true,
            'data' => [
                'user' => [
                    'id'                => $user->id,
                    'username'          => $user->username,
                    'avatar_url'        => $user->avatar_url,
                    'bio'               => $user->bio,
                    'reputation_points' => $user->reputation_points,
                    'rank_level'        => $user->rank_level,
                    'level'             => $user->level,
                    'created_at'        => $user->created_at,
                    'followers_count'   => $user->followers()->count(),
                    'following_count'   => $user->followings()->count(),
                ],
                'is_following'  => $isFollowing,
                'threads'       => $threads,
                'threads_count' => $threads->count(),
            ]
        ]);
    }

    /**
     * PROTECTED: Update profil sendiri
     * POST /api/profile/update
     */
    public function updateProfile(Request $request)
    {
        $user = auth('api')->user();

        $validator = Validator::make($request->all(), [
            'bio'    => 'nullable|string|max:500',
            'avatar' => 'nullable|image|mimes:jpeg,png,jpg|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        if ($request->hasFile('avatar')) {
            $file = $request->file('avatar');
            $path = $file->store('avatars', 'public');
            $user->avatar_url = asset('storage/' . $path);
        }

        if ($request->has('bio')) {
            $user->bio = $request->bio;
        }

        $user->save();

        return response()->json([
            'success' => true,
            'message' => 'Profil kamu berhasil diperbarui, bro!',
            'user'    => $user
        ]);
    }
}

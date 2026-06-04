<?php

namespace App\Http\Controllers\Api; // <--- Perhatikan ada tambahan \Api di sini

use App\Http\Controllers\Controller; // <--- Wajib di-import karena posisi Controller utama ada di luar folder Api
use App\Models\User;
use Illuminate\Http\Request;

class FollowController extends Controller
{
    public function toggleFollow($id)
{
    $me = auth('api')->user();

    // 1. Validasi apakah user sudah login atau belum
    if (!$me) {
        return response()->json([
            // Gunakan format baku untuk respon API profesional
            'success' => false,
            'message' => 'Unauthenticated. Silakan login terlebih dahulu.'
        ], 401);
    }

    $targetUser = User::find($id);

    // 2. Validasi apakah user target ada di database
    if (!$targetUser) {
        return response()->json([
            'success' => false,
            'message' => 'User tidak ditemukan.'
        ], 404);
    }

    // 3. Validasi agar tidak bisa mem-follow diri sendiri
    if ($me->id === $targetUser->id) {
        return response()->json([
            'success' => false,
            'message' => 'Kamu tidak dapat mem-follow akunmu sendiri.'
        ], 400);
    }

    // Prosedur toggle hubungan relasi Many-to-Many
    $attached = $me->followings()->toggle($targetUser->id);

    if (count($attached['attached']) > 0) {
        return response()->json([
            'success' => true,
            'message' => 'Berhasil mengikuti ' . $targetUser->username
        ], 200);
    } else {
        return response()->json([
            'success' => true,
            'message' => 'Berhasil berhenti mengikuti ' . $targetUser->username
        ], 200);
    }
}
}
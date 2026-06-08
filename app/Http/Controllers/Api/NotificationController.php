<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
    /**
     * AMBIL SEMUA NOTIFIKASI USER
     */
    public function index(Request $request)
    {
        $user = auth('api')->user();
        
        // PERBAIKAN NYAMAN: Validasi token/sesi pengguna sebelum memproses query
        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'Sesi login tidak valid atau kadaluarsa.'
            ], 401);
        }
        
        // Default ambil semua, tapi bisa difilter hanya yang 'unread'
        $query = $user->notifications();

        if ($request->query('filter') === 'unread') {
            $query = $user->unreadNotifications();
        }

        $notifications = $query->paginate(15);

        return response()->json([
            'success' => true,
            'message' => 'Daftar notifikasi berhasil diambil.',
            'unread_count' => $user->unreadNotifications()->count(),
            'data' => $notifications
        ], 200);
    }

    /**
     * TANDAI SATU NOTIFIKASI SEBAGAI TERBACA
     */
    public function markAsRead($id)
    {
        $user = auth('api')->user();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'Sesi login tidak valid atau kadaluarsa.'
            ], 401);
        }

        $notification = $user->notifications()->where('id', $id)->first();

        if (!$notification) {
            return response()->json([
                'success' => false,
                'message' => 'Notifikasi tidak ditemukan.'
            ], 404);
        }

        $notification->markAsRead();

        return response()->json([
            'success' => true,
            'message' => 'Notifikasi berhasil ditandai sebagai terbaca.'
        ], 200);
    }

    /**
     * TANDAI SEMUA NOTIFIKASI SEBAGAI TERBACA
     */
    public function markAllAsRead()
    {
        $user = auth('api')->user();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'Sesi login tidak valid atau kadaluarsa.'
            ], 401);
        }

        // PERBAIKAN RINGAN: Gunakan unreadNotifications() berupa method query agar lebih efisien untuk data banyak
        $user->unreadNotifications()->update(['read_at' => now()]);

        return response()->json([
            'success' => true,
            'message' => 'Semua notifikasi berhasil ditandai sebagai terbaca.'
        ], 200);
    }

    /**
     * HAPUS SATU NOTIFIKASI
     */
    public function destroy($id)
    {
        $user = auth('api')->user();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'Sesi login tidak valid atau kadaluarsa.'
            ], 401);
        }

        $notification = $user->notifications()->where('id', $id)->first();

        if (!$notification) {
            return response()->json([
                'success' => false,
                'message' => 'Notifikasi tidak ditemukan.'
            ], 404);
        }

        $notification->delete();

        return response()->json([
            'success' => true,
            'message' => 'Notifikasi berhasil dihapus.'
        ], 200);
    }
}
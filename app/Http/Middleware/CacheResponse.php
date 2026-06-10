<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Symfony\Component\HttpFoundation\Response;

class CacheResponse
{
    /**
     * Menangani permintaan yang masuk.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     * @param  int  $ttl  Durasi penyimpanan cache dalam satuan detik (default: 60)
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function handle(Request $request, Closure $next, int $ttl = 60): Response
    {
        // BYPASS: Jika sedang dalam mode testing/local, jangan gunakan cache agar hasil tetap akurat.
        // KECUALI jika request meminta pengetesan middleware secara eksplisit.
        if (app()->environment('testing', 'local') && !$request->hasHeader('X-Test-Middleware')) {
            return $next($request);
        }

        // 1. Hanya lakukan cache untuk metode GET
        if (!$request->isMethod('GET')) {
            return $next($request);
        }

        // 2. Ambil data User ID jika pengguna sudah login (untuk membedakan cache antar user)
        $userId = auth('api')->id() ?? 'public';

        // 3. Buat kunci cache unik berdasarkan URL, query string, dan User ID
        $cacheKey = 'cache_' . $userId . '_' . md5($request->fullUrl());

        // 4. Periksa apakah data cache sudah tersedia di memori
        if (Cache::has($cacheKey)) {
            $cachedData = Cache::get($cacheKey);
            
            // Mengembalikan respons langsung dari cache dalam format JSON
            return response()->json($cachedData['content'], $cachedData['status'])
                             ->header('X-Cache', 'HIT'); // Penanda bahwa data diambil dari cache
        }

        // 5. Jika cache belum ada, teruskan request ke Controller untuk mengambil data segar
        $response = $next($request);

        // 6. Simpan respons ke dalam cache hanya jika status kodenya sukses (200 OK)
        if ($response->getStatusCode() === 200) {
            // Mengambil konten asli dari objek respons
            $responseData = json_decode($response->getContent(), true);

            if ($responseData) {
                Cache::put($cacheKey, [
                    'content' => $responseData,
                    'status' => $response->getStatusCode()
                ], $ttl);
            }
        }

        // Kembalikan respons asli dengan penanda cache MISS
        return $response->header('X-Cache', 'MISS');
    }
}
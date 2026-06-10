<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\RateLimiter;
use Symfony\Component\HttpFoundation\Response;

class RateLimitMiddleware
{
    /**
     * Menangani permintaan yang masuk.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     * @param  int  $maxAttempts  Maksimal jumlah request yang diperbolehkan (default: 60)
     * @param  int  $decayMinutes Durasi penguncian/reset dalam satuan menit (default: 1)
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function handle(Request $request, Closure $next, int $maxAttempts = 220, int $decayMinutes = 1): Response
    {
        // BYPASS: Jika sedang dalam mode testing/local, jangan batasi request agar Cypress & Test lancar.
        // KECUALI jika request meminta pengetesan middleware secara eksplisit.
        if (app()->environment('testing', 'local') && !$request->hasHeader('X-Test-Middleware')) {
            return $next($request);
        }

        // Bypass tambahan khusus Cypress (jika environment non-local pun tetap lancar)
        if (str_contains($request->userAgent(), 'Cypress')) {
            return $next($request);
        }

        // 1. Buat kunci limiter unik (Berdasarkan User ID jika login, atau IP Address jika public)
        $userId = auth('api')->id() ?? $request->ip();
        $limiterKey = 'rate_limit_' . md5($userId . '_' . $request->route()->getName());

        // 2. Periksa apakah user telah melewati batas request
        if (RateLimiter::tooManyAttempts($limiterKey, $maxAttempts)) {
            $secondsLeft = RateLimiter::availableIn($limiterKey);

            return response()->json([
                'status' => 'error',
                'message' => 'Terlalu banyak permintaan (Too Many Requests).',
                'retry_after_seconds' => $secondsLeft
            ], 429)->withHeaders([
                'Retry-After' => $secondsLeft,
                'X-RateLimit-Limit' => $maxAttempts,
                'X-RateLimit-Remaining' => 0,
            ]);
        }

        // 3. Catat atau hitung request yang masuk
        RateLimiter::hit($limiterKey, $decayMinutes * 60);

        // 4. Lanjutkan request ke Controller dan ambil response-nya
        $response = $next($request);

        // 5. Tambahkan informasi limit pada Header response sebagai indikator bagi Frontend
        return $response->withHeaders([
            'X-RateLimit-Limit' => $maxAttempts,
            'X-RateLimit-Remaining' => RateLimiter::remaining($limiterKey, $maxAttempts),
        ]);
    }
}
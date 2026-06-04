<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckRole
{
    public function handle(Request $request, Closure $next, ...$roles): Response
    {
        // Pastikan guard menggunakan 'api' untuk JWT
        $user = auth('api')->user();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'Anda harus login terlebih dahulu.'
            ], 401);
        }

        if (!$user->hasRole($roles)) {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak! Anda tidak memiliki hak akses untuk fitur ini.'
            ], 403);
        }

        return $next($request);
    }
}
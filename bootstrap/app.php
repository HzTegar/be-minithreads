<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware) {
        // 1. Daftarkan semua Global Middleware di sini (CORS)
        $middleware->append(
            \Illuminate\Http\Middleware\HandleCors::class
        );

        // 2. Daftarkan semua Alias Middleware Kustom kamu di sini
        $middleware->alias([
            'role'           => \App\Http\Middleware\CheckRole::class,
            'cache.response' => \App\Http\Middleware\CacheResponse::class,
            'rate.limit'     => \App\Http\Middleware\RateLimitMiddleware::class,
        ]);
    })
    ->withExceptions(function (Exceptions $exceptions) {
        // Tempat konfigurasi exception handling jika diperlukan
    })
    ->create();
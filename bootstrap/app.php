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
        $middleware->alias([
            'role' => \App\Http\Middleware\CheckRole::class,
            //mendaftarkan middleware cache.response kustom
            'cache.response' => \App\Http\Middleware\CacheResponse::class,
            //mendaftarkan alias rute untuk rate limiter kustom 
             'rate.limit' => \App\Http\Middleware\RateLimitMiddleware::class,
        ]);
    })
    ->withMiddleware(function (Middleware $middleware) {

    $middleware->append(
        \Illuminate\Http\Middleware\HandleCors::class
    );

    $middleware->alias([
        'role' => \App\Http\Middleware\CheckRole::class,
        'cache.response' => \App\Http\Middleware\CacheResponse::class,
        'rate.limit' => \App\Http\Middleware\RateLimitMiddleware::class,
    ]);
})
    ->withExceptions(function (Exceptions $exceptions): void {
        //
    })->create();
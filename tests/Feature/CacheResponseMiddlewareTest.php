<?php

namespace Tests\Feature;

use Tests\TestCase;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Route;
use App\Http\Middleware\CacheResponse; // Pastikan mengarah ke class yang benar
use PHPUnit\Framework\Attributes\Test;

class CacheResponseMiddlewareTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();

        // 1. Bersihkan cache setiap kali test dimulai
        Cache::flush();

        // 2. Daftarkan route tiruan menggunakan class middleware yang benar
        Route::get('/test-cache-middleware', function () {
            return response()->json(['data' => microtime(true)]);
        })->middleware(CacheResponse::class);
    }

    #[Test]
    public function middleware_menyimpan_response_ke_dalam_cache_pada_request_pertama()
    {
        // Generate key cache sesuai formula di middleware (public karena belum login)
        $cacheKey = 'cache_public_' . md5(url('/test-cache-middleware'));
        $this->assertFalse(Cache::has($cacheKey));

        // Hit pertama -> Harus MISS
        $response = $this->withHeader('X-Test-Middleware', 'true')->get('/test-cache-middleware');

        $response->assertStatus(200)
                 ->assertHeader('X-Cache', 'MISS');

        // Pastikan sekarang data sudah tersimpan di cache
        $this->assertTrue(Cache::has($cacheKey));
        
        // Pastikan struktur cache sesuai dengan yang disimpan middleware Anda
        $cachedData = Cache::get($cacheKey);
        $this->assertArrayHasKey('content', $cachedData);
        $this->assertArrayHasKey('status', $cachedData);
    }

    #[Test]
    public function middleware_mengambil_data_dari_cache_pada_request_kedua()
    {
        // Hit pertama untuk memicu pembuatan cache
        $response1 = $this->withHeader('X-Test-Middleware', 'true')->get('/test-cache-middleware');
        $content1 = $response1->getContent();

        // Hit kedua -> Harus HIT
        $response2 = $this->withHeader('X-Test-Middleware', 'true')->get('/test-cache-middleware');

        $response2->assertStatus(200)
                 ->assertHeader('X-Cache', 'HIT');

        // Memastikan data yang dikembalikan sama persis (diambil dari cache)
        $this->assertEquals($content1, $response2->getContent());
    }
}
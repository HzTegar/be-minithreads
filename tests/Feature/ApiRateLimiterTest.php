<?php

namespace Tests\Feature;

use Tests\TestCase;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Foundation\Testing\RefreshDatabase; // 1. IMPORT TRAIT REFRESH DATABASE
use PHPUnit\Framework\Attributes\Test;

class ApiRateLimiterTest extends TestCase
{
    use RefreshDatabase; // 2. GUNAKAN TRAIT DI DALAM CLASS TEST

    protected function setUp(): void
    {
        parent::setUp();

        // Bersihkan catatan limiter di cache sebelum test berjalan
        Cache::flush();
    }

    #[Test]
    public function rute_auth_login_memiliki_batasan_rate_limit_yang_ketat()
    {
        for ($i = 0; $i < 10; $i++) {
            $response = $this->withHeader('X-Test-Middleware', 'true')->postJson('/api/auth/login', [
                'email' => 'test@example.com',
                'password' => 'password123'
            ]);

            $this->assertNotEquals(429, $response->getStatusCode());
        }

        $finalResponse = $this->withHeader('X-Test-Middleware', 'true')->postJson('/api/auth/login', [
            'email' => 'test@example.com',
            'password' => 'password123'
        ]);

        $finalResponse->assertStatus(429);
        $finalResponse->assertJsonStructure([
            'status',
            'message',
            'retry_after_seconds'
        ]);
    }

    #[Test]
    public function rute_posts_publik_mengembalikan_header_rate_limit_yang_sesuai()
    {
        // Hit pertama ke rute publik posts (Tabel posts sekarang sudah ada karena RefreshDatabase)
        $response = $this->withHeader('X-Test-Middleware', 'true')->getJson('/api/posts');

        // Pastikan rute berhasil diakses dan membawa header limit (60 request)
        $response->assertStatus(200)
                 ->assertHeader('X-RateLimit-Limit', 60);
                 
        // Sisa jatah request harus berkurang menjadi 59
        $this->assertEquals(59, $response->headers->get('X-RateLimit-Remaining'));
    }

    #[Test]
    public function rute_search_global_membatasi_request_sesuai_konfigurasi()
    {
        for ($i = 0; $i < 30; $i++) {
            $response = $this->withHeader('X-Test-Middleware', 'true')->getJson('/api/search/global?q=laravel');
            $this->assertNotEquals(429, $response->getStatusCode());
        }

        $finalResponse = $this->withHeader('X-Test-Middleware', 'true')->getJson('/api/search/global?q=laravel');
        $finalResponse->assertStatus(429);
    }
}
<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\User;
use Illuminate\Support\Facades\Cache;
use Illuminate\Foundation\Testing\RefreshDatabase;
use PHPUnit\Framework\Attributes\Test;

class ApiRateLimiterTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        // Bersihkan catatan limiter di cache sebelum setiap test berjalan
        Cache::flush();
    }

    #[Test]
    public function rute_auth_login_memiliki_batasan_rate_limit_yang_sesuai()
    {
        // 1. BUAT USER BARU: Mencegah kegagalan autentikasi (401) sebelum menyentuh limit
        User::factory()->create([
            'email' => 'test@example.com',
            'password_hash' => bcrypt('password123'),
        ]);

        // Lakukan looping sebanyak 200 kali (sesuai konfigurasi baru)
        for ($i = 0; $i < 200; $i++) {
            $response = $this->withHeader('X-Test-Middleware', 'true')->postJson('/api/auth/login', [
                'email' => 'test@example.com',
                'password' => 'password-salah'
            ]);

            $this->assertNotEquals(429, $response->getStatusCode(), "Gagal pada iterasi ke-$i");
        }

        // Request ke-201: Harus terkena rate limit (429)
        $finalResponse = $this->withHeader('X-Test-Middleware', 'true')->postJson('/api/auth/login', [
            'email' => 'test@example.com',
            'password' => 'password-salah'
        ]);

        $finalResponse->assertStatus(429);
        
        // Sesuaikan dengan struktur JSON yang dikembalikan oleh RateLimitMiddleware
        $finalResponse->assertJsonStructure([
            'status',
            'message',
            'retry_after_seconds'
        ]);
    }

    #[Test]
    public function rute_posts_publik_mengembalikan_header_rate_limit_yang_sesuai()
    {
        // Hit pertama ke rute publik posts
        $response = $this->withHeader('X-Test-Middleware', 'true')->getJson('/api/posts');

        // Pastikan rute berhasil diakses
        $response->assertStatus(200);
                 
        $this->assertTrue(
            $response->headers->has('X-RateLimit-Limit') || $response->headers->has('x-ratelimit-limit'),
            'Header X-RateLimit-Limit tidak ditemukan, bro.'
        );
        
        $this->assertEquals(200, $response->headers->get('X-RateLimit-Limit'));
    }

    #[Test]
    public function rute_search_global_membatasi_request_sesuai_konfigurasi()
    {
        // Lakukan looping sebanyak 200 kali sesuai konfigurasi baru
        for ($i = 0; $i < 200; $i++) {
            $response = $this->withHeader('X-Test-Middleware', 'true')->getJson('/api/search/global?keyword=laravel');
            $this->assertNotEquals(429, $response->getStatusCode(), "Gagal pada iterasi ke-$i");
        }

        // Request ke-201: Harus terblokir (429)
        $finalResponse = $this->withHeader('X-Test-Middleware', 'true')->getJson('/api/search/global?keyword=laravel');
        $finalResponse->assertStatus(429);
    }
}

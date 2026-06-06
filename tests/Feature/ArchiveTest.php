<?php

namespace Tests\Feature;

use App\Models\Category;
use App\Models\Comment;
use App\Models\Post;
use App\Models\User;
use App\Models\Role;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;
use Carbon\Carbon;
use Tymon\JWTAuth\Facades\JWTAuth;

class ArchiveTest extends TestCase
{
    use RefreshDatabase;

    protected $user;
    protected $token;
    protected $category;

    protected function setUp(): void
    {
        parent::setUp();

        // Create Roles
        Role::create(['name' => 'user']);
        Role::create(['name' => 'admin']);
        Role::create(['name' => 'moderator']);

        $this->user = User::factory()->create();
        $this->token = JWTAuth::fromUser($this->user);
        $this->category = Category::create(['name' => 'General', 'slug' => 'general']);
    }

    /** @test */
    public function user_cannot_close_unanswered_post()
    {
        $post = Post::create([
            'user_id' => $this->user->id,
            'category_id' => $this->category->id,
            'title' => 'Unanswered Question',
            'slug' => 'unanswered-question',
            'body' => 'How to do X?',
            'status' => 'open',
            'is_answered' => false,
        ]);

        $response = $this->withHeader('Authorization', 'Bearer ' . $this->token)
            ->postJson("/api/posts/{$post->id}/toggle-archive");

        $response->assertStatus(400);
        $response->assertJsonFragment(['message' => 'Postingan belum bisa ditutup karena belum ada jawaban terbaik yang dipilih, bro.']);
    }

    /** @test */
    public function user_can_close_answered_post()
    {
        $post = Post::create([
            'user_id' => $this->user->id,
            'category_id' => $this->category->id,
            'title' => 'Answered Question',
            'slug' => 'answered-question',
            'body' => 'How to do Y?',
            'status' => 'open',
            'is_answered' => true,
        ]);

        $response = $this->withHeader('Authorization', 'Bearer ' . $this->token)
            ->postJson("/api/posts/{$post->id}/toggle-archive");

        $response->assertStatus(200);
        $response->assertJsonFragment(['message' => 'Postingan berhasil diarsipkan. Kamu punya waktu 24 jam jika ingin membukanya kembali.']);
        $this->assertEquals('closed', $post->fresh()->status);
    }

    /** @test */
    public function user_can_reopen_post_within_24_hours()
    {
        $post = Post::create([
            'user_id' => $this->user->id,
            'category_id' => $this->category->id,
            'title' => 'Closed Question',
            'slug' => 'closed-question',
            'body' => 'How to do Z?',
            'status' => 'closed',
            'closed_at' => now()->subHours(23),
            'is_answered' => true,
        ]);

        $response = $this->withHeader('Authorization', 'Bearer ' . $this->token)
            ->postJson("/api/posts/{$post->id}/toggle-archive");

        $response->assertStatus(200);
        $response->assertJsonFragment(['message' => 'Postingan berhasil dipublikasikan kembali!']);
        $this->assertEquals('open', $post->fresh()->status);
    }

    /** @test */
    public function user_cannot_reopen_post_after_24_hours()
    {
        $post = Post::create([
            'user_id' => $this->user->id,
            'category_id' => $this->category->id,
            'title' => 'Permanently Closed Question',
            'slug' => 'permanently-closed-question',
            'body' => 'How to do W?',
            'status' => 'closed',
            'closed_at' => now()->subHours(25),
            'is_answered' => true,
        ]);

        $response = $this->withHeader('Authorization', 'Bearer ' . $this->token)
            ->postJson("/api/posts/{$post->id}/toggle-archive");

        $response->assertStatus(400);
        $response->assertJsonFragment(['message' => 'Postingan sudah terarsip selamanya karena sudah lebih dari 24 jam, bro.']);
        $this->assertEquals('closed', $post->fresh()->status);
    }

    /** @test */
    public function cannot_comment_on_closed_post()
    {
        $post = Post::create([
            'user_id' => $this->user->id,
            'category_id' => $this->category->id,
            'title' => 'Closed Post',
            'slug' => 'closed-post',
            'body' => 'This is closed.',
            'status' => 'closed',
            'closed_at' => now(),
            'is_answered' => true,
        ]);

        $response = $this->withHeader('Authorization', 'Bearer ' . $this->token)
            ->postJson("/api/posts/{$post->id}/comments", [
                'body' => 'Trying to comment.'
            ]);

        $response->assertStatus(403);
        $response->assertJsonFragment(['message' => 'Postingan ini sudah diarsipkan/ditutup, kamu tidak bisa menambah komentar lagi, bro.']);
    }
}

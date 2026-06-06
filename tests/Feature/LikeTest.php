<?php

namespace Tests\Feature;

use App\Models\Category;
use App\Models\Post;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;
use Tymon\JWTAuth\Facades\JWTAuth;

class LikeTest extends TestCase
{
    use RefreshDatabase;

    protected $user;
    protected $token;
    protected $category;
    protected $post;

    protected function setUp(): void
    {
        parent::setUp();

        // Buat user untuk testing
        $this->user = User::factory()->create([
            'password_hash' => bcrypt('password123'),
            'level' => 'user'
        ]);

        // Generate JWT Token
        $this->token = JWTAuth::fromUser($this->user);

        // Buat kategori dan postingan
        $this->category = Category::create([
            'name' => 'Tech',
            'slug' => 'tech',
            'description' => 'Technology category'
        ]);

        $this->post = Post::create([
            'user_id' => $this->user->id,
            'category_id' => $this->category->id,
            'title' => 'Testing Like Feature',
            'slug' => 'testing-like-feature',
            'body' => 'This is a test post for like feature.',
            'status' => 'open'
        ]);
    }

    /** @test */
    public function user_can_like_a_post()
    {
        $response = $this->withHeaders(['Authorization' => "Bearer $this->token"])
            ->postJson('/api/like', [
                'target_id' => $this->post->id,
                'target_type' => 'post'
            ]);

        $response->assertStatus(201)
            ->assertJson([
                'success' => true,
                'message' => 'Post berhasil di-like, bro!',
                'is_liked' => true,
                'likes_count' => 1
            ]);

        $this->assertDatabaseHas('likes', [
            'user_id' => $this->user->id,
            'target_id' => $this->post->id,
            'target_type' => Post::class
        ]);
    }

    /** @test */
    public function user_can_like_a_comment()
    {
        $comment = \App\Models\Comment::create([
            'post_id' => $this->post->id,
            'user_id' => $this->user->id,
            'body' => 'Test comment'
        ]);

        $response = $this->withHeaders(['Authorization' => "Bearer $this->token"])
            ->postJson('/api/like', [
                'target_id' => $comment->id,
                'target_type' => 'comment'
            ]);

        $response->assertStatus(201)
            ->assertJson([
                'success' => true,
                'message' => 'Komentar berhasil di-like, bro!',
                'is_liked' => true,
                'likes_count' => 1
            ]);

        $this->assertDatabaseHas('likes', [
            'user_id' => $this->user->id,
            'target_id' => $comment->id,
            'target_type' => \App\Models\Comment::class
        ]);
    }

    /** @test */
    public function user_can_unlike_a_comment()
    {
        $comment = \App\Models\Comment::create([
            'post_id' => $this->post->id,
            'user_id' => $this->user->id,
            'body' => 'Test comment'
        ]);

        // Like dulu
        $comment->likes()->create(['user_id' => $this->user->id]);

        $response = $this->withHeaders(['Authorization' => "Bearer $this->token"])
            ->postJson('/api/like', [
                'target_id' => $comment->id,
                'target_type' => 'comment'
            ]);

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'message' => 'Komentar berhasil batal di-like, bro!',
                'is_liked' => false,
                'likes_count' => 0
            ]);

        $this->assertDatabaseMissing('likes', [
            'user_id' => $this->user->id,
            'target_id' => $comment->id,
            'target_type' => \App\Models\Comment::class
        ]);
    }

    /** @test */
    public function user_can_unlike_a_post()
    {
        // Like dulu
        $this->post->likes()->create(['user_id' => $this->user->id]);

        $response = $this->withHeaders(['Authorization' => "Bearer $this->token"])
            ->postJson('/api/like', [
                'target_id' => $this->post->id,
                'target_type' => 'post'
            ]);

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'message' => 'Post berhasil batal di-like, bro!',
                'is_liked' => false,
                'likes_count' => 0
            ]);

        $this->assertDatabaseMissing('likes', [
            'user_id' => $this->user->id,
            'target_id' => $this->post->id,
            'target_type' => Post::class
        ]);
    }

    /** @test */
    public function show_post_returns_correct_like_info()
    {
        // Like postingan oleh user lain
        $otherUser = User::factory()->create();
        $this->post->likes()->create(['user_id' => $otherUser->id]);

        // Cek response show (tanpa login)
        $response = $this->getJson("/api/posts/{$this->post->id}");
        $response->assertStatus(200)
            ->assertJsonFragment(['likes_count' => 1, 'is_liked' => false]);

        // Cek response show (dengan login user yang belum like)
        $response = $this->withHeaders(['Authorization' => "Bearer $this->token"])
            ->getJson("/api/posts/{$this->post->id}");
        $response->assertStatus(200)
            ->assertJsonFragment(['likes_count' => 1, 'is_liked' => false]);

        // User login lalu like
        $this->post->likes()->create(['user_id' => $this->user->id]);

        // Cek response show lagi
        $response = $this->withHeaders(['Authorization' => "Bearer $this->token"])
            ->getJson("/api/posts/{$this->post->id}");
        $response->assertStatus(200)
            ->assertJsonFragment(['likes_count' => 2, 'is_liked' => true]);
    }

    /** @test */
    public function show_post_returns_correct_like_info_for_comments()
    {
        $comment = \App\Models\Comment::create([
            'post_id' => $this->post->id,
            'user_id' => $this->user->id,
            'body' => 'Test comment'
        ]);

        // Like komentar oleh user lain
        $otherUser = User::factory()->create();
        $comment->likes()->create(['user_id' => $otherUser->id]);

        // Cek response show (tanpa login)
        $response = $this->getJson("/api/posts/{$this->post->id}");
        $response->assertStatus(200);
        $data = $response->json('data');
        $this->assertEquals(1, $data['comments'][0]['likes_count']);
        $this->assertFalse($data['comments'][0]['is_liked']);

        // Cek response show (dengan login user yang belum like)
        $response = $this->withHeaders(['Authorization' => "Bearer $this->token"])
            ->getJson("/api/posts/{$this->post->id}");
        $response->assertStatus(200);
        $data = $response->json('data');
        $this->assertFalse($data['comments'][0]['is_liked']);

        // User login lalu like komentar
        $comment->likes()->create(['user_id' => $this->user->id]);

        // Cek response show lagi
        $response = $this->withHeaders(['Authorization' => "Bearer $this->token"])
            ->getJson("/api/posts/{$this->post->id}");
        $response->assertStatus(200);
        $data = $response->json('data');
        $this->assertEquals(2, $data['comments'][0]['likes_count']);
        $this->assertTrue($data['comments'][0]['is_liked']);
    }
}

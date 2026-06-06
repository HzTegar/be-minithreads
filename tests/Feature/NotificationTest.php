<?php

namespace Tests\Feature;

use App\Models\Category;
use App\Models\Post;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;
use Tymon\JWTAuth\Facades\JWTAuth;

class NotificationTest extends TestCase
{
    use RefreshDatabase;

    protected $user1;
    protected $user2;
    protected $token1;
    protected $token2;
    protected $category;
    protected $post;

    protected function setUp(): void
    {
        parent::setUp();

        $this->user1 = User::factory()->create(['username' => 'user1']);
        $this->user2 = User::factory()->create(['username' => 'user2']);
        
        $this->token1 = JWTAuth::fromUser($this->user1);
        $this->token2 = JWTAuth::fromUser($this->user2);

        $this->category = Category::create(['name' => 'Tech', 'slug' => 'tech', 'description' => 'Tech category']);
        
        $this->post = Post::create([
            'user_id' => $this->user1->id,
            'category_id' => $this->category->id,
            'title' => 'Post User 1',
            'slug' => 'post-user-1',
            'body' => 'Body content',
            'status' => 'open'
        ]);
    }

    /** @test */
    public function user_receives_notification_when_post_is_commented()
    {
        $this->withHeaders(['Authorization' => "Bearer $this->token2"])
            ->postJson("/api/posts/{$this->post->id}/comments", [
                'body' => 'Komentar dari user 2'
            ]);

        $this->assertEquals(1, $this->user1->unreadNotifications()->count());
        $notification = $this->user1->unreadNotifications()->first();
        $this->assertEquals('new_comment', $notification->data['type']);
        $this->assertStringContainsString('user2 berkomentar di postinganmu', $notification->data['message']);
    }

    /** @test */
    public function user_receives_notification_when_post_is_liked()
    {
        $this->withHeaders(['Authorization' => "Bearer $this->token2"])
            ->postJson("/api/like", [
                'target_id' => $this->post->id,
                'target_type' => 'post'
            ]);

        $this->assertEquals(1, $this->user1->unreadNotifications()->count());
        $notification = $this->user1->unreadNotifications()->first();
        $this->assertEquals('post_liked', $notification->data['type']);
    }

    /** @test */
    public function user_receives_notification_when_followed()
    {
        $this->withHeaders(['Authorization' => "Bearer $this->token2"])
            ->postJson("/api/user/follow/{$this->user1->id}");

        $this->assertEquals(1, $this->user1->unreadNotifications()->count());
        $notification = $this->user1->unreadNotifications()->first();
        $this->assertEquals('user_followed', $notification->data['type']);
    }

    /** @test */
    public function user_can_get_their_notifications()
    {
        // Beri 1 notifikasi
        $this->user1->notify(new \App\Notifications\UserFollowedNotification($this->user2));

        $response = $this->withHeaders(['Authorization' => "Bearer $this->token1"])
            ->getJson("/api/notifications");

        $response->assertStatus(200)
            ->assertJsonCount(1, 'data.data')
            ->assertJsonPath('unread_count', 1);
    }

    /** @test */
    public function user_can_mark_notification_as_read()
    {
        $this->user1->notify(new \App\Notifications\UserFollowedNotification($this->user2));
        $notification = $this->user1->unreadNotifications()->first();

        $response = $this->withHeaders(['Authorization' => "Bearer $this->token1"])
            ->postJson("/api/notifications/{$notification->id}/read");

        $response->assertStatus(200);
        $this->assertEquals(0, $this->user1->unreadNotifications()->count());
    }
}

<?php

namespace Tests\Feature;

use App\Models\Category;
use App\Models\Comment;
use App\Models\Post;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;
use Tymon\JWTAuth\Facades\JWTAuth;

class AcceptedAnswerTest extends TestCase
{
    use RefreshDatabase;

    protected $owner;
    protected $otherUser;
    protected $post;
    protected $category;

    protected function setUp(): void
    {
        parent::setUp();

        $this->owner = User::factory()->create();
        $this->otherUser = User::factory()->create();
        $this->category = Category::create([
            'id' => \Illuminate\Support\Str::uuid(),
            'name' => 'Test Category',
            'slug' => 'test-category'
        ]);

        $this->post = Post::create([
            'user_id' => $this->owner->id,
            'category_id' => $this->category->id,
            'title' => 'Sample Question',
            'slug' => 'sample-question',
            'body' => 'How to do this?',
        ]);
    }

    public function test_only_owner_can_accept_answer()
    {
        $comment = Comment::create([
            'post_id' => $this->post->id,
            'user_id' => $this->otherUser->id,
            'body' => 'This is the solution'
        ]);

        // Non-owner try to accept
        $response = $this->actingAs($this->otherUser, 'api')->postJson(
            "/api/posts/{$this->post->id}/comments/{$comment->id}/toggle-accepted"
        );

        $response->assertStatus(403);

        // Owner accept
        $response = $this->actingAs($this->owner, 'api')->postJson(
            "/api/posts/{$this->post->id}/comments/{$comment->id}/toggle-accepted"
        );

        $response->assertStatus(200);
        $this->assertTrue($comment->fresh()->is_accepted);
        $this->assertEquals($comment->id, $this->post->fresh()->accepted_answer_id);
    }

    public function test_accepting_answer_awards_points()
    {
        $commentAuthor = User::factory()->create();
        $comment = Comment::create([
            'post_id' => $this->post->id,
            'user_id' => $commentAuthor->id,
            'body' => 'This is the solution'
        ]);

        $initialPoints = $commentAuthor->reputation_points;

        $this->actingAs($this->owner, 'api')->postJson(
            "/api/posts/{$this->post->id}/comments/{$comment->id}/toggle-accepted"
        );

        $this->assertEquals($initialPoints + 15, $commentAuthor->fresh()->reputation_points);
        $this->assertDatabaseHas('points_logs', [
            'user_id' => $commentAuthor->id,
            'points' => 15,
            'action_type' => 'accepted_answer_received'
        ]);
    }

    public function test_switching_accepted_answer_transfers_points()
    {
        $author1 = User::factory()->create();
        $author2 = User::factory()->create();

        $comment1 = Comment::create([
            'post_id' => $this->post->id,
            'user_id' => $author1->id,
            'body' => 'Solution 1'
        ]);

        $comment2 = Comment::create([
            'post_id' => $this->post->id,
            'user_id' => $author2->id,
            'body' => 'Solution 2'
        ]);

        // Accept comment 1
        $this->actingAs($this->owner, 'api')->postJson(
            "/api/posts/{$this->post->id}/comments/{$comment1->id}/toggle-accepted"
        );

        $this->assertEquals(15, $author1->fresh()->reputation_points);

        // Switch to comment 2
        $this->actingAs($this->owner, 'api')->postJson(
            "/api/posts/{$this->post->id}/comments/{$comment2->id}/toggle-accepted"
        );

        $this->assertEquals(0, $author1->fresh()->reputation_points);
        $this->assertEquals(15, $author2->fresh()->reputation_points);
        $this->assertFalse($comment1->fresh()->is_accepted);
        $this->assertTrue($comment2->fresh()->is_accepted);
    }
}

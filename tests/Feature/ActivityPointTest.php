<?php

namespace Tests\Feature;

use App\Models\User;
use App\Models\Post;
use App\Models\Category;
use App\Models\Comment;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ActivityPointTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_gets_10_points_for_liking_post()
    {
        $user = User::factory()->create(['reputation_points' => 0]);
        $author = User::factory()->create();
        $category = Category::factory()->create();
        $post = Post::factory()->create(['user_id' => $author->id, 'category_id' => $category->id]);
        
        $token = auth('api')->login($user);

        $response = $this->withHeader('Authorization', "Bearer $token")
            ->postJson('/api/like', [
                'target_id' => $post->id,
                'target_type' => 'post'
            ]);

        $response->assertStatus(201);
        $user->refresh();
        $this->assertEquals(10, $user->reputation_points);

        // Unlike
        $response = $this->withHeader('Authorization', "Bearer $token")
            ->postJson('/api/like', [
                'target_id' => $post->id,
                'target_type' => 'post'
            ]);
        
        $user->refresh();
        $this->assertEquals(0, $user->reputation_points);
    }

    public function test_user_gets_5_points_for_upvoting()
    {
        $user = User::factory()->create(['reputation_points' => 0]);
        $author = User::factory()->create();
        $category = Category::factory()->create();
        $post = Post::factory()->create(['user_id' => $author->id, 'category_id' => $category->id]);
        
        $token = auth('api')->login($user);

        $response = $this->withHeader('Authorization', "Bearer $token")
            ->postJson('/api/vote', [
                'target_id' => $post->id,
                'target_type' => 'post',
                'vote_type' => 'up'
            ]);

        $response->assertStatus(201);
        $user->refresh();
        $this->assertEquals(5, $user->reputation_points);

        // Cancel upvote
        $response = $this->withHeader('Authorization', "Bearer $token")
            ->postJson('/api/vote', [
                'target_id' => $post->id,
                'target_type' => 'post',
                'vote_type' => 'up'
            ]);
        
        $user->refresh();
        $this->assertEquals(0, $user->reputation_points);
    }

    public function test_user_loses_5_points_for_downvoting()
    {
        $user = User::factory()->create(['reputation_points' => 10]);
        $author = User::factory()->create();
        $category = Category::factory()->create();
        $post = Post::factory()->create(['user_id' => $author->id, 'category_id' => $category->id]);
        
        $token = auth('api')->login($user);

        $response = $this->withHeader('Authorization', "Bearer $token")
            ->postJson('/api/vote', [
                'target_id' => $post->id,
                'target_type' => 'post',
                'vote_type' => 'down'
            ]);

        $response->assertStatus(201);
        $user->refresh();
        $this->assertEquals(5, $user->reputation_points);

        // Cancel downvote
        $response = $this->withHeader('Authorization', "Bearer $token")
            ->postJson('/api/vote', [
                'target_id' => $post->id,
                'target_type' => 'post',
                'vote_type' => 'down'
            ]);
        
        $user->refresh();
        $this->assertEquals(10, $user->reputation_points);
    }

    public function test_user_points_adjust_correctly_when_switching_votes()
    {
        $user = User::factory()->create(['reputation_points' => 10]);
        $author = User::factory()->create();
        $category = Category::factory()->create();
        $post = Post::factory()->create(['user_id' => $author->id, 'category_id' => $category->id]);
        
        $token = auth('api')->login($user);

        // Downvote first (-5)
        $this->withHeader('Authorization', "Bearer $token")
            ->postJson('/api/vote', [
                'target_id' => $post->id,
                'target_type' => 'post',
                'vote_type' => 'down'
            ]);
        
        $user->refresh();
        $this->assertEquals(5, $user->reputation_points);

        // Switch to upvote (+5 from old downvote removal, +5 from new upvote) = +10 net
        $this->withHeader('Authorization', "Bearer $token")
            ->postJson('/api/vote', [
                'target_id' => $post->id,
                'target_type' => 'post',
                'vote_type' => 'up'
            ]);
        
        $user->refresh();
        $this->assertEquals(15, $user->reputation_points);
    }
}

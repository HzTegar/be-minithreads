<?php

namespace Tests\Feature;

use App\Models\User;
use App\Models\Category;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class PostPointRestrictionTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_cannot_post_without_20_points()
    {
        $user = User::factory()->create(['reputation_points' => 10]);
        $category = Category::factory()->create();
        
        $token = auth('api')->login($user);

        $response = $this->withHeader('Authorization', "Bearer $token")
            ->postJson('/api/posts', [
                'category_id' => $category->id,
                'title' => 'Test Post Title',
                'body' => 'Test Post Body',
                'tags' => ['test']
            ]);

        $response->assertStatus(403);
        $response->assertJsonFragment([
            'success' => false,
            'message' => 'Waduh! Poin kamu belum cukup untuk posting, bro. Minimal kamu harus punya 20 poin. Yuk, aktif dulu ngevote atau ngelike konten orang lain!'
        ]);
    }

    public function test_user_can_post_with_20_points()
    {
        $user = User::factory()->create(['reputation_points' => 20]);
        $category = Category::factory()->create();
        
        $token = auth('api')->login($user);

        $response = $this->withHeader('Authorization', "Bearer $token")
            ->postJson('/api/posts', [
                'category_id' => $category->id,
                'title' => 'Test Post Title',
                'body' => 'Test Post Body',
                'tags' => ['test']
            ]);

        $response->assertStatus(201);
    }
}

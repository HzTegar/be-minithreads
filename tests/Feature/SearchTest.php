<?php

namespace Tests\Feature;

use App\Models\Category;
use App\Models\Post;
use App\Models\Tag;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class SearchTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        // Buat Data Dummy
        $user = User::factory()->create(['username' => 'budi_kece']);
        $category = Category::create(['name' => 'Laravel', 'slug' => 'laravel', 'description' => 'Laravel Framework']);
        $tag = Tag::create(['name' => 'PHP', 'slug' => 'php']);

        $post = Post::create([
            'user_id' => $user->id,
            'category_id' => $category->id,
            'title' => 'Tutorial Ngoding Laravel untuk Pemula',
            'slug' => 'tutorial-ngoding-laravel',
            'body' => 'Ini adalah tutorial ngoding laravel yang sangat mudah.',
            'status' => 'open'
        ]);
        $post->tags()->attach($tag->id);

        $post->comments()->create([
            'user_id' => $user->id,
            'body' => 'Wah bermanfaat banget bro!'
        ]);
    }

    /** @test */
    public function can_search_posts_by_title()
    {
        $response = $this->getJson('/api/search/posts?keyword=Tutorial');

        $response->assertStatus(200)
            ->assertJsonPath('data.data.0.title', 'Tutorial Ngoding Laravel untuk Pemula')
            ->assertJsonStructure(['data' => ['data' => [['user', 'category', 'tags', 'comments']]]]);
    }

    /** @test */
    public function can_search_posts_by_category_name()
    {
        $response = $this->getJson('/api/search/posts?keyword=Laravel');

        $response->assertStatus(200)
            ->assertJsonCount(1, 'data.data');
    }

    /** @test */
    public function can_search_posts_by_tag_name()
    {
        $response = $this->getJson('/api/search/posts?keyword=PHP');

        $response->assertStatus(200)
            ->assertJsonCount(1, 'data.data');
    }

    /** @test */
    public function can_search_users()
    {
        $response = $this->getJson('/api/search/users?keyword=budi');

        $response->assertStatus(200)
            ->assertJsonPath('data.data.0.username', 'budi_kece');
    }

    /** @test */
    public function can_search_global()
    {
        $response = $this->getJson('/api/search/global?keyword=Laravel');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'data' => [
                    'posts',
                    'users',
                    'tags',
                    'categories'
                ]
            ]);
        
        $this->assertNotEmpty($response->json('data.posts'));
        $this->assertNotEmpty($response->json('data.categories'));
    }
}

<?php

namespace Tests\Feature;

use App\Models\Category;
use App\Models\Comment;
use App\Models\Post;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;
use Tymon\JWTAuth\Facades\JWTAuth;

class EditHistoryTest extends TestCase
{
    use RefreshDatabase;

    protected $user;
    protected $token;
    protected $admin;
    protected $adminToken;
    protected $category;

    protected function setUp(): void
    {
        parent::setUp();

        $this->user = User::factory()->create(['level' => 'user']);
        $this->token = JWTAuth::fromUser($this->user);

        $this->admin = User::factory()->create(['level' => 'admin']);
        $this->adminToken = JWTAuth::fromUser($this->admin);

        $this->category = Category::create(['name' => 'General', 'slug' => 'general']);
    }

    public function test_post_edit_limit_and_history()
    {
        $post = Post::create([
            'user_id' => $this->user->id,
            'category_id' => $this->category->id,
            'title' => 'Original Title',
            'slug' => 'original-title',
            'body' => 'Original Body',
        ]);

        // Edit 1
        $response = $this->withHeader('Authorization', "Bearer $this->token")
            ->putJson("/api/posts/{$post->id}", [
                'category_id' => $this->category->id,
                'title' => 'Edit 1 Title',
                'body' => 'Edit 1 Body',
                'tags' => ['laravel', 'php']
            ]);

        $response->assertStatus(200);
        $this->assertEquals(1, $post->fresh()->edit_count);
        $this->assertDatabaseHas('post_edit_histories', ['post_id' => $post->id, 'edit_number' => 1]);

        // Edit 2
        $this->withHeader('Authorization', "Bearer $this->token")
            ->putJson("/api/posts/{$post->id}", [
                'category_id' => $this->category->id,
                'title' => 'Edit 2 Title',
                'body' => 'Edit 2 Body',
            ]);

        // Edit 3
        $this->withHeader('Authorization', "Bearer $this->token")
            ->putJson("/api/posts/{$post->id}", [
                'category_id' => $this->category->id,
                'title' => 'Edit 3 Title',
                'body' => 'Edit 3 Body',
            ]);

        $this->assertEquals(3, $post->fresh()->edit_count);

        // Edit 4 (Should fail)
        $response = $this->withHeader('Authorization', "Bearer $this->token")
            ->putJson("/api/posts/{$post->id}", [
                'category_id' => $this->category->id,
                'title' => 'Edit 4 Title',
                'body' => 'Edit 4 Body',
            ]);

        $response->assertStatus(400);
        $response->assertJsonPath('message', 'Slot edit habis! Kamu hanya dibatasi mengedit postingan maksimal 3 kali, bro.');
    }

    public function test_comment_edit_limit_and_history()
    {
        $post = Post::create([
            'user_id' => $this->user->id,
            'category_id' => $this->category->id,
            'title' => 'Post for Comment',
            'slug' => 'post-for-comment',
            'body' => 'Body',
        ]);

        $comment = Comment::create([
            'post_id' => $post->id,
            'user_id' => $this->user->id,
            'body' => 'Original Comment',
        ]);

        // Edit 1
        $response = $this->withHeader('Authorization', "Bearer $this->token")
            ->putJson("/api/comments/{$comment->id}", [
                'body' => 'Edited Comment',
            ]);

        $response->assertStatus(200);
        $this->assertTrue($comment->fresh()->is_edited);
        $this->assertDatabaseHas('comment_edit_histories', ['comment_id' => $comment->id]);

        // Edit 2 (Should fail)
        $response = $this->withHeader('Authorization', "Bearer $this->token")
            ->putJson("/api/comments/{$comment->id}", [
                'body' => 'Edited Again',
            ]);

        $response->assertStatus(400);
        $response->assertJsonPath('message', 'Slot edit habis! Kamu hanya dibatasi mengedit komentar 1 kali per postingan, bro.');
    }

    public function test_tag_auto_creation()
    {
        $response = $this->withHeader('Authorization', "Bearer $this->token")
            ->postJson("/api/posts", [
                'category_id' => $this->category->id,
                'title' => 'Post with Tags',
                'body' => 'Body with tags',
                'tags' => ['newtag1', 'newtag2']
            ]);

        $response->assertStatus(201);
        $this->assertDatabaseHas('tags', ['name' => 'newtag1']);
        $this->assertDatabaseHas('tags', ['name' => 'newtag2']);

        // Reuse tag
        $response = $this->withHeader('Authorization', "Bearer $this->token")
            ->postJson("/api/posts", [
                'category_id' => $this->category->id,
                'title' => 'Post with Existing Tag',
                'body' => 'Body',
                'tags' => ['newtag1', 'brandnewtag']
            ]);

        $response->assertStatus(201);
        $this->assertDatabaseHas('tags', ['name' => 'brandnewtag']);
        $this->assertCount(3, \App\Models\Tag::all());
    }

    public function test_history_visibility()
    {
        $post = Post::create([
            'user_id' => $this->user->id,
            'category_id' => $this->category->id,
            'title' => 'History Visibility Test',
            'slug' => 'history-visibility-test',
            'body' => 'Body',
        ]);

        // Edit the post
        $this->withHeader('Authorization', "Bearer $this->token")
            ->putJson("/api/posts/{$post->id}", [
                'category_id' => $this->category->id,
                'title' => 'Edited Title',
                'body' => 'Edited Body',
            ]);

        // View as regular user
        $response = $this->getJson("/api/posts/{$post->id}");
        $response->assertStatus(200);
        $response->assertJsonMissing(['edit_histories']);

        // View as admin
        $response = $this->actingAs($this->admin, 'api')
            ->getJson("/api/posts/{$post->id}");

        $response->assertStatus(200);
        $response->assertJsonStructure(['data' => ['edit_histories']]);
    }
}

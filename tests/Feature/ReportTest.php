<?php

namespace Tests\Feature;

use App\Models\Category;
use App\Models\Post;
use App\Models\User;
use App\Models\Report;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;
use Tymon\JWTAuth\Facades\JWTAuth;

class ReportTest extends TestCase
{
    use RefreshDatabase;

    protected $user;
    protected $admin;
    protected $tokenUser;
    protected $tokenAdmin;
    protected $post;

    protected function setUp(): void
    {
        parent::setUp();

        $this->user = User::factory()->create(['level' => 'user']);
        $this->admin = User::factory()->create(['level' => 'admin']);
        
        $this->tokenUser = JWTAuth::fromUser($this->user);
        $this->tokenAdmin = JWTAuth::fromUser($this->admin);

        $category = Category::create(['name' => 'General', 'slug' => 'general', 'description' => 'General category']);
        
        $this->post = Post::create([
            'user_id' => $this->admin->id, // Post milik admin agar bisa dilaporkan user
            'category_id' => $category->id,
            'title' => 'Bad Post',
            'slug' => 'bad-post',
            'body' => 'Spam content here',
            'status' => 'open'
        ]);
    }

    /** @test */
    public function user_can_report_a_post()
    {
        $response = $this->withHeaders(['Authorization' => "Bearer $this->tokenUser"])
            ->postJson('/api/reports', [
                'target_id' => $this->post->id,
                'target_type' => 'post',
                'reason' => 'Spam',
                'description' => 'This is definitely spam.'
            ]);

        $response->assertStatus(201)
            ->assertJsonPath('success', true);

        $this->assertDatabaseHas('reports', [
            'user_id' => $this->user->id,
            'target_id' => $this->post->id,
            'reason' => 'Spam'
        ]);
    }

    /** @test */
    public function admin_can_see_reports()
    {
        Report::create([
            'user_id' => $this->user->id,
            'target_id' => $this->post->id,
            'target_type' => Post::class,
            'reason' => 'Harassment',
            'status' => 'pending'
        ]);

        $response = $this->withHeaders(['Authorization' => "Bearer $this->tokenAdmin"])
            ->getJson('/api/admin/reports');

        $response->assertStatus(200)
            ->assertJsonCount(1, 'data.data');
    }

    /** @test */
    public function user_cannot_see_admin_reports()
    {
        $response = $this->withHeaders(['Authorization' => "Bearer $this->tokenUser"])
            ->getJson('/api/admin/reports');

        $response->assertStatus(403);
    }

    /** @test */
    public function admin_can_update_report_status()
    {
        $report = Report::create([
            'user_id' => $this->user->id,
            'target_id' => $this->post->id,
            'target_type' => Post::class,
            'reason' => 'Spam',
            'status' => 'pending'
        ]);

        $response = $this->withHeaders(['Authorization' => "Bearer $this->tokenAdmin"])
            ->putJson("/api/admin/reports/{$report->id}", [
                'status' => 'resolved',
                'moderator_notes' => 'Post has been checked.'
            ]);

        $response->assertStatus(200)
            ->assertJsonPath('data.status', 'resolved');

        $this->assertDatabaseHas('reports', [
            'id' => $report->id,
            'status' => 'resolved',
            'resolved_by' => $this->admin->id
        ]);
    }
}

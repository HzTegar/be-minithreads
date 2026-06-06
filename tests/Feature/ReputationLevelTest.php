<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ReputationLevelTest extends TestCase
{
    use RefreshDatabase;

    /** @test */
    public function user_has_default_rank_newbie()
    {
        $user = User::factory()->create(['reputation_points' => 0]);
        $this->assertEquals('Newbie', $user->rank_level);
    }

    /** @test */
    public function user_rank_updates_based_on_points()
    {
        $user = User::factory()->create(['reputation_points' => 0]);

        // 50 Poin -> Regular
        $user->reputation_points = 55;
        $user->save();
        $this->assertEquals('Regular', $user->rank_level);

        // 200 Poin -> Pro
        $user->reputation_points = 210;
        $user->save();
        $this->assertEquals('Pro', $user->rank_level);

        // 1000 Poin -> Master
        $user->reputation_points = 1050;
        $user->save();
        $this->assertEquals('Master', $user->rank_level);
    }

    /** @test */
    public function rank_level_is_included_in_json_response()
    {
        $user = User::factory()->create(['reputation_points' => 60]);
        
        $response = $this->actingAs($user, 'api')->getJson('/api/auth/me');

        $response->assertStatus(200)
            ->assertJsonPath('user.rank_level', 'Regular');
    }
}

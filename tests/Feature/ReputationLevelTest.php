<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ReputationLevelTest extends TestCase
{
    use RefreshDatabase;

    /** @test */
    public function user_has_default_rank_bronze()
    {
        $user = User::factory()->create(['reputation_points' => 0]);
        $this->assertEquals('Bronze', $user->rank_level);
    }

    /** @test */
    public function user_rank_updates_based_on_points()
    {
        $user = User::factory()->create(['reputation_points' => 0]);

        // 20 Poin -> Silver
        $user->reputation_points = 25;
        $user->save();
        $this->assertEquals('Silver', $user->rank_level);

        // 100 Poin -> Gold
        $user->reputation_points = 110;
        $user->save();
        $this->assertEquals('Gold', $user->rank_level);

        // 500 Poin -> Platinum
        $user->reputation_points = 510;
        $user->save();
        $this->assertEquals('Platinum', $user->rank_level);

        // 1000 Poin -> Diamond
        $user->reputation_points = 1050;
        $user->save();
        $this->assertEquals('Diamond', $user->rank_level);

        // 1500 Poin -> Master
        $user->reputation_points = 1550;
        $user->save();
        $this->assertEquals('Master', $user->rank_level);

        // 2500 Poin -> Grand Master
        $user->reputation_points = 2600;
        $user->save();
        $this->assertEquals('Grand Master', $user->rank_level);
    }

    /** @test */
    public function rank_level_is_included_in_json_response()
    {
        $user = User::factory()->create(['reputation_points' => 120]);
        
        $response = $this->actingAs($user, 'api')->getJson('/api/auth/me');

        $response->assertStatus(200)
            ->assertJsonPath('user.rank_level', 'Gold');
    }
}

<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Post;
use App\Models\Tag;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class PostSeeder extends Seeder
{
    public function run(): void
    {
        $users = User::all();
        $categories = Category::all();
        $tags = Tag::all();

        if ($users->isEmpty() || $categories->isEmpty()) {
            return;
        }

        // Create 20 random posts
        for ($i = 1; $i <= 20; $i++) {
            $title = fake()->sentence();
            $post = Post::create([
                'user_id' => $users->random()->id,
                'category_id' => $categories->random()->id,
                'title' => $title,
                'slug' => Str::slug($title) . '-' . Str::random(5),
                'body' => fake()->paragraphs(3, true),
                'status' => 'open',
                'view_count' => rand(10, 500),
                'vote_score' => rand(-5, 50),
                'published_at' => now()->subDays(rand(0, 30)),
            ]);

            // Attach 1-3 random tags
            $post->tags()->attach(
                $tags->random(rand(1, 3))->pluck('id')->toArray()
            );
        }
    }
}

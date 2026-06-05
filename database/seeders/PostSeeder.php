<?php

namespace Database\Seeders;

use App\Models\Post;
use App\Models\Category;
use App\Models\User;
use App\Models\Tag;
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

        // Buat 20 postingan dummy
        for ($i = 1; $i <= 20; $i++) {
            $title = "Judul Postingan Dummy Ke-$i: " . Str::random(10);
            $post = Post::create([
                'user_id'     => $users->random()->id,
                'category_id' => $categories->random()->id,
                'title'       => $title,
                'slug'        => Str::slug($title) . '-' . Str::random(5),
                'body'        => "Ini adalah isi konten dummy untuk postingan ke-$i. " . Str::random(100),
                'status'      => 'open',
                'edit_count'  => 0,
            ]);

            // Tempelkan 1-3 tag secara acak
            $randomTags = $tags->random(rand(1, 3))->pluck('id');
            $post->tags()->attach($randomTags);
        }
    }
}

<?php

namespace Database\Seeders;

use App\Models\Tag;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class TagSeeder extends Seeder
{
    public function run(): void
    {
        $tags = [
            ['name' => 'Laravel', 'color' => '#ff2d20'],
            ['name' => 'PHP', 'color' => '#777bb4'],
            ['name' => 'JavaScript', 'color' => '#f7df1e'],
            ['name' => 'React', 'color' => '#61dafb'],
            ['name' => 'Vue', 'color' => '#42b883'],
            ['name' => 'Tutorial', 'color' => '#000000'],
            ['name' => 'Help', 'color' => '#ff0000'],
            ['name' => 'Showcase', 'color' => '#00ff00'],
        ];

        foreach ($tags as $tag) {
            Tag::create([
                'name' => $tag['name'],
                'slug' => Str::slug($tag['name']),
                'color' => $tag['color'],
            ]);
        }
    }
}

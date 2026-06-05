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
            'Laravel', 'React', 'Vue', 'Tailwind', 'Python', 'PHP',
            'Fitness', 'Nutrisi', 'Traveling', 'Kopi', 'Gaming',
            'AI', 'Blockchain', 'Cloud', 'CyberSecurity'
        ];

        foreach ($tags as $tagName) {
            Tag::create([
                'name' => $tagName,
                'slug' => Str::slug($tagName),
                'color' => '#' . str_pad(dechex(mt_rand(0, 0xFFFFFF)), 6, '0', STR_PAD_LEFT),
            ]);
        }
    }
}

<?php

namespace Database\Seeders;

use App\Models\Category;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class CategorySeeder extends Seeder
{
    public function run(): void
    {
        $categories = [
            ['name' => 'Teknologi', 'description' => 'Diskusi seputar gadget, software, dan inovasi terbaru.'],
            ['name' => 'Programming', 'description' => 'Tempat berbagi kode, tutorial, dan tips programming.'],
            ['name' => 'Kesehatan', 'description' => 'Informasi dan tips menjaga kesehatan tubuh dan mental.'],
            ['name' => 'Gaya Hidup', 'description' => 'Diskusi hobi, fashion, dan aktivitas sehari-hari.'],
            ['name' => 'Pendidikan', 'description' => 'Berbagi ilmu pengetahuan, beasiswa, dan info kampus.'],
            ['name' => 'Hiburan', 'description' => 'Film, musik, game, dan berita selebriti.'],
        ];

        foreach ($categories as $category) {
            Category::create([
                'name' => $category['name'],
                'slug' => Str::slug($category['name']),
                'description' => $category['description'],
            ]);
        }
    }
}

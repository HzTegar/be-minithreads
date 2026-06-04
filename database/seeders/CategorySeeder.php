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
            ['id' => '9b5d8e7a-1234-4a56-b789-123456789abc', 'name' => 'Web Development'],
            ['id' => '9b5d8e7a-1234-4a56-b789-223456789abc', 'name' => 'Mobile Development'],
            ['id' => '9b5d8e7a-1234-4a56-b789-323456789abc', 'name' => 'Backend & API'],
            ['id' => '9b5d8e7a-1234-4a56-b789-423456789abc', 'name' => 'Database & DevOps'],
            ['id' => '9b5d8e7a-1234-4a56-b789-523456789abc', 'name' => 'UI/UX Design'],
            ['id' => '9b5d8e7a-1234-4a56-b789-623456789abc', 'name' => 'General Discussion'],
        ];

        foreach ($categories as $cat) {
            Category::create([
                'id'   => $cat['id'],
                'name' => $cat['name'],
                'slug' => Str::slug($cat['name']),
            ]);
        }
    }
}
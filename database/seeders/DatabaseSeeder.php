<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // Seed Roles and Categories first
        $this->call([
            RoleSeeder::class,
            CategorySeeder::class,
            TagSeeder::class,
        ]);

        // 1. Admin
        User::create([
            'username' => 'admin_super',
            'email' => 'admin@minithreads.com',
            'password_hash' => Hash::make('password123'),
            'level' => 'admin',
        ]);

        // 2. Moderator
        User::create([
            'username' => 'mod_kece',
            'email' => 'moderator@minithreads.com',
            'password_hash' => Hash::make('password123'),
            'level' => 'moderator',
        ]);

        // 3. User Biasa
        User::create([
            'username' => 'user_biasa',
            'email' => 'user@minithreads.com',
            'password_hash' => Hash::make('password123'),
            'level' => 'user',
        ]);

        // 4. Random Users
        User::factory(10)->create();

        // 5. Posts
        $this->call([
            PostSeeder::class,
        ]);
    }
}
<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // 1. Akun Tetap untuk Testing (Semua kolom disesuaikan dengan skema database Anda)
        User::create([
            'username' => 'admin_super', // Konsisten dengan sebelumnya
            'email' => 'admin@minithreads.com',
            'password_hash' => Hash::make('password123'), // Sesuai dengan Cypress test
            'level' => 'admin',
        ]);

        User::create([
            'username' => 'mod_kece',
            'email' => 'moderator@minithreads.com',
            'password_hash' => Hash::make('password123'),
            'level' => 'moderator',
        ]);

        User::create([
            'username' => 'user_biasa',
            'email' => 'user@minithreads.com',
            'password_hash' => Hash::make('password123'),
            'level' => 'user',
        ]);

        // 2. Random Users tambahan
        User::factory(5)->create();

        // 3. Panggil Seeder Data Dummy lainnya
        $this->call([
            CategorySeeder::class,
            TagSeeder::class,
            PostSeeder::class,
        ]);
    }
}
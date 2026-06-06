<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // 1. Akun Tetap untuk Testing
        // Pastikan tidak duplikat jika dijalankan ulang
        $users = [
            [
                'username' => 'admin_super',
                'email' => 'admin@minithreads.com',
                'password_hash' => Hash::make('password123'),
                'level' => 'admin',
                'bio' => 'Saya adalah Admin Super di Mini Threads.',
            ],
            [
                'username' => 'mod_kece',
                'email' => 'moderator@minithreads.com',
                'password_hash' => Hash::make('password123'),
                'level' => 'moderator',
                'bio' => 'Moderator yang siap menjaga komunitas.',
            ],
            [
                'username' => 'user_biasa',
                'email' => 'user@minithreads.com',
                'password_hash' => Hash::make('password123'),
                'level' => 'user',
                'bio' => 'Hanya user biasa yang suka membaca.',
            ]
        ];

        foreach ($users as $userData) {
            User::firstOrCreate(
                ['email' => $userData['email']],
                $userData
            );
        }

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

<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Role;
use Illuminate\Support\Str;

class RoleSeeder extends Seeder
{
    public function run(): void
    {
        $roles = ['admin', 'moderator', 'user'];

        foreach ($roles as $roleName) {
            // Menggunakan updateOrCreate agar jika dijalankan ulang tidak duplikat
            Role::updateOrCreate(
                ['name' => $roleName],
                [
                    'id' => (string) Str::uuid(), // Otomatis generate UUID jika model tidak mengaturnya
                    'permissions' => json_encode([]), // Default json kosong sesuai struktur kolommu
                ]
            );
        }
    }
}
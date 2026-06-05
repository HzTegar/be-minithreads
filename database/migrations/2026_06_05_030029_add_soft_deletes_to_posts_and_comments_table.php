<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // 1. Tambahkan soft delete ke tabel posts
        Schema::table('posts', function (Blueprint $table) {
            $table->softDeletes(); // Otomatis membuat kolom 'deleted_at' (nullable)
        });

        // 2. Tambahkan soft delete ke tabel comments
        Schema::table('comments', function (Blueprint $table) {
            $table->softDeletes(); // Otomatis membuat kolom 'deleted_at' (nullable)
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Batalkan perubahan jika migrasi di-rollback
        Schema::table('posts', function (Blueprint $table) {
            $table->dropSoftDeletes();
        });

        Schema::table('comments', function (Blueprint $table) {
            $table->dropSoftDeletes();
        });
    }
};
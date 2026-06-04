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
        // 1. Buat tabel comments terlebih dahulu
        if (!Schema::hasTable('comments')) {
            Schema::create('comments', function (Blueprint $table) {
                $table->uuid('id')->primary();
                $table->uuid('post_id')->index();
                $table->uuid('user_id')->index();
                $table->uuid('parent_id')->nullable()->index();
                $table->text('body');
                $table->integer('vote_score')->default(0);
                $table->boolean('is_accepted')->default(false); // Penanda di sisi komentar
                $table->timestamps();

                $table->foreign('post_id')->references('id')->on('posts')->onDelete('cascade');
                $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
                $table->foreign('parent_id')->references('id')->on('comments')->onDelete('cascade');
            });
        }

        // 2. Modifikasi tabel posts untuk menambahkan kolom jawaban terbaik
        Schema::table('posts', function (Blueprint $table) {
            // Cek apakah kolom belum ada, baru buat fisiknya
            if (!Schema::hasColumn('posts', 'accepted_answer_id')) {
                $table->uuid('accepted_answer_id')->nullable()->after('id');
            }
        });

        // 3. Pasang Foreign Key secara terpisah agar aman dari kendala urutan pembuatan tabel
        Schema::table('posts', function (Blueprint $table) {
            $table->foreign('accepted_answer_id')->references('id')->on('comments')->onDelete('set null');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Drop foreign key di posts dulu sebelum menghapus tabel comments
        if (Schema::hasTable('posts') && Schema::hasColumn('posts', 'accepted_answer_id')) {
            Schema::table('posts', function (Blueprint $table) {
                // Gunakan try-catch agar jika foreign key sudah hilang, proses rollback tidak putus di tengah jalan
                try {
                    $table->dropForeign(['accepted_answer_id']);
                } catch (\Exception $e) {
                    // Berjalan silent jika FK memang tidak ditemukan
                }
                $table->dropColumn('accepted_answer_id');
            });
        }

        // Baru hapus tabel comments secara aman
        Schema::dropIfExists('comments');
    }
};
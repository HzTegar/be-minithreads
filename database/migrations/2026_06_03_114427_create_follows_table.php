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
        Schema::create('follows', function (Blueprint $table) {
            // Perbaikan: Menghapus $table->uuid('id')->primary() karena tidak diperlukan di tabel pivot
            
            $table->uuid('follower_id');
            $table->uuid('following_id');
            $table->timestamps();

            // Foreign key constraints ke tabel users
            $table->foreign('follower_id')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('following_id')->references('id')->on('users')->onDelete('cascade');
            
            // Menjadikan kedua kolom ini sebagai Composite Primary Key
            // Ini otomatis mencegah data ganda (tidak bisa follow user yang sama 2x) dan menggantikan fungsi unique()
            $table->primary(['follower_id', 'following_id']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('follows');
    }
};
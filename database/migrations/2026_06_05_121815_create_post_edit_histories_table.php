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
        Schema::create('post_edit_histories', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignUuid('post_id')->constrained()->onDelete('cascade');
            $table->string('old_title')->nullable();
            $table->string('new_title')->nullable();
            $table->text('old_body')->nullable();
            $table->text('new_body')->nullable();
            $table->integer('edit_number');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('post_edit_histories');
    }
};

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
        Schema::create('posts', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('user_id')->index();
            $table->uuid('category_id')->index();
            $table->string('title', 300);
            $table->text('body');
            $table->string('status', 20)->default('open');
            $table->integer('view_count')->default(0);
            $table->integer('vote_score')->default(0);
            $table->boolean('is_answered')->default(false);
            $table->uuid('accepted_answer_id')->nullable();
            $table->timestamps();

            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('category_id')->references('id')->on('categories')->onDelete('restrict');
            // accepted_answer_id FK will be added later or kept as is due to circular dependency
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('posts');
    }
};

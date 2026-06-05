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
        Schema::table('posts', function (Blueprint $table) {
            $table->integer('edit_count')->default(0)->after('status');
        });

        Schema::table('comments', function (Blueprint $table) {
            $table->boolean('is_edited')->default(false)->after('body');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('posts', function (Blueprint $table) {
            $table->dropColumn('edit_count');
        });

        Schema::table('comments', function (Blueprint $table) {
            $table->dropColumn('is_edited');
        });
    }
};

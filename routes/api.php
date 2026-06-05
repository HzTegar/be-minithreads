<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\FollowController;
use App\Http\Controllers\Api\PostController;
use App\Http\Controllers\Api\TagController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\CommentController;
use App\Http\Controllers\Api\VoteController;
use App\Http\Controllers\Api\BookmarkController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

// 1. RUTE PUBLIK (Tanpa Login)
Route::group(['prefix' => 'auth'], function () {
    Route::post('register', [AuthController::class, 'register']);
    Route::post('login', [AuthController::class, 'login']);
});

Route::get('posts', [PostController::class, 'index']);
Route::get('posts/{id}', [PostController::class, 'show']);

Route::get('tags', [TagController::class, 'index']);
Route::get('tags/{id}', [TagController::class, 'show']);

Route::get('categories', [CategoryController::class, 'index']);
Route::get('categories/{id}', [CategoryController::class, 'show']);


// 2. RUTE PROTECTED (Wajib Login dengan JWT)
Route::middleware('auth:api')->group(function () {
    
    // Auth & Profile
    Route::group(['prefix' => 'auth'], function () {
        Route::get('me', [AuthController::class, 'me']);
        Route::post('logout', [AuthController::class, 'logout']);
        Route::get('admin/dashboard', [AuthController::class, 'dashboard']);
    });
    // Rute untuk melihat seluruh daftar postingan yang disimpan
    Route::get('/bookmarks', [BookmarkController::class, 'index']);
    
    // Rute untuk melakukan aksi simpan/batal simpan bookmark
    Route::post('/posts/{postId}/bookmark', [BookmarkController::class, 'toggle']);

    Route::post('profile/update', [ProfileController::class, 'updateProfile']);

    // Social
    Route::post('user/follow/{id}', [FollowController::class, 'toggleFollow']);

    // Posts Management
    Route::post('posts', [PostController::class, 'store']);
    Route::put('posts/{id}', [PostController::class, 'update']);
    Route::delete('posts/{id}', [PostController::class, 'destroy']);
    Route::post('/posts/{postId}/comments/{commentId}/toggle-accepted', [PostController::class, 'toggleAcceptedAnswer']);
    
    // Tags Management (Hanya Admin)
    Route::middleware('role:admin')->group(function () {
        Route::post('tags', [TagController::class, 'store']);
        Route::put('tags/{id}', [TagController::class, 'update']);
        Route::delete('tags/{id}', [TagController::class, 'destroy']);
    });

    // Dummy Route for Admin/Moderator Test
    Route::middleware('role:admin,moderator')->group(function () {
        Route::post('threads/delete-palsu', function () {
            return response()->json(['message' => 'Thread berhasil dihapus oleh Moderator/Admin.']);
        });
    });
    
    Route::middleware('auth:api')->group(function () {
    
    // Rute untuk melihat seluruh daftar postingan yang disimpan
    Route::get('/bookmarks', [BookmarkController::class, 'index']);
    
    // Rute untuk melakukan aksi simpan/batal simpan bookmark
    Route::post('/posts/{postId}/bookmark', [BookmarkController::class, 'toggle']);

});

    // Bisa diakses Admin dan Moderator (Store & Update)
    Route::post('categories', [CategoryController::class, 'store']);
    Route::put('categories/{id}', [CategoryController::class, 'update']);

    // hanya bisa diakses oleh admin (delete/destroy)
    Route::delete('categories/{id}', [CategoryController::class, 'destroy']);

    // TAMBAHKAN ROUTE INI UNTUK KOMENTAR
    Route::post('/posts/{postId}/comments', [CommentController::class, 'store']);
    Route::put('/comments/{id}', [CommentController::class, 'update']);
    // Route Toggle Accepted Answer Anda...
    Route::post('/posts/{postId}/comments/{commentId}/toggle-accepted', [PostController::class, 'toggleAcceptedAnswer']);
    // TAMBAHKAN BARIS INI: Rute untuk menghapus elemen komentar (Penyembunyian Semu)
    Route::delete('/comments/{id}', [CommentController::class, 'destroy']);
    
    // Jalur endpoint untuk melakukan proses upvote dan downvote
    Route::post('/vote', [VoteController::class, 'handleVote']);
});

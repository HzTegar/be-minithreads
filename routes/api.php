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
use App\Http\Controllers\Api\LikeController;
use App\Http\Controllers\Api\NotificationController;
use App\Http\Controllers\Api\ReportController;
use App\Http\Controllers\Api\SearchController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

// ==========================================
// 1. RUTE PUBLIK (Tanpa Login) 
// ==========================================

// Proteksi ketat untuk Login & Register (Maksimal 10 request per 1 menit untuk mencegah brute-force)
Route::group(['prefix' => 'auth', 'middleware' => 'rate.limit:10,1'], function () {
    Route::post('register', [AuthController::class, 'register']);
    Route::post('login', [AuthController::class, 'login']);
});

// Proteksi global untuk fitur pencarian (Maksimal 30 request per 1 menit)
Route::group(['prefix' => 'search', 'middleware' => 'rate.limit:30,1'], function () {
    Route::get('global', [SearchController::class, 'searchGlobal']);
    Route::get('posts', [SearchController::class, 'searchPosts']);
    Route::get('users', [SearchController::class, 'searchUsers']);
    Route::get('tags', [SearchController::class, 'searchTags']);
    Route::get('categories', [SearchController::class, 'searchCategories']);
});

// Konten Publik Read-Only dengan kombinasi Cache dan Rate Limiter (Maksimal 60 request per 1 menit)
Route::group(['middleware' => 'rate.limit:60,1'], function () {
    // Rute utama posts tetap dipertahankan dan sekarang mendukung parameter filter kaku maupun pencarian kata kunci teks bebas (?keyword=)
    Route::get('posts', [PostController::class, 'index'])->middleware('cache.response:60');
    Route::get('posts/{id}', [PostController::class, 'show'])->middleware('cache.response:300');

    Route::get('tags', [TagController::class, 'index'])->middleware('cache.response:60');
    Route::get('tags/{id}', [TagController::class, 'show'])->middleware('cache.response:300');

    Route::get('categories', [CategoryController::class, 'index'])->middleware('cache.response:60');
    Route::get('categories/{id}', [CategoryController::class, 'show'])->middleware('cache.response:300');

    // Public user profile
    Route::get('users/{username}', [\App\Http\Controllers\Api\ProfileController::class, 'show']);
});


// ==========================================
// 2. RUTE PROTECTED (Wajib Login JWT)
// ==========================================

// Menerapkan rate limit standar untuk pengguna yang sudah login (Maksimal 100 request per 1 menit)
Route::middleware(['auth:api', 'rate.limit:100,1'])->group(function () {
    
    // Auth & Profile
    Route::group(['prefix' => 'auth'], function () {
        Route::get('me', [AuthController::class, 'me']);
        Route::post('logout', [AuthController::class, 'logout']);
        Route::get('admin/dashboard', [AuthController::class, 'dashboard']);
    });
    
    Route::post('profile/update', [ProfileController::class, 'updateProfile']);

    // Bookmarks
    Route::get('/bookmarks', [BookmarkController::class, 'index']);
    Route::post('/posts/{postId}/bookmark', [BookmarkController::class, 'toggle']);

    // Posts Management (User Biasa) - Dibatasi lebih ketat khusus untuk membuat/mengubah postingan (Maksimal 10 post per 1 menit)
    Route::post('posts', [PostController::class, 'store'])->middleware('rate.limit:10,1');
    Route::put('posts/{id}', [PostController::class, 'update']);
    Route::delete('posts/{id}', [PostController::class, 'destroy']);
    Route::get('/posts/{id}/history', [PostController::class, 'viewHistory']);
    Route::post('/posts/{id}/toggle-archive', [PostController::class, 'toggleArchive']);
    Route::post('/posts/{postId}/comments/{commentId}/toggle-accepted', [PostController::class, 'toggleAcceptedAnswer']);

    // Social & Interactions (Follow, Vote, Like) - Batasi spam klik (Maksimal 20 interaction per 1 menit)
    Route::post('user/follow/{id}', [FollowController::class, 'toggleFollow'])->middleware('rate.limit:20,1');
    Route::post('/vote', [VoteController::class, 'handleVote'])->middleware('rate.limit:20,1');
    Route::post('/like', [LikeController::class, 'handleLike'])->middleware('rate.limit:20,1');

    // Comments Management - Batasi pembuatan komentar (Maksimal 15 komentar per 1 menit)
    Route::post('/posts/{postId}/comments', [CommentController::class, 'store'])->middleware('rate.limit:15,1');
    Route::put('/comments/{id}', [CommentController::class, 'update']);
    Route::delete('/comments/{id}', [CommentController::class, 'destroy']);
    Route::get('/comments/{id}/history', [CommentController::class, 'viewHistory']);
    Route::post('/comments/{id}/like', [CommentController::class, 'toggleLike'])->middleware('rate.limit:20,1');

    // Notifications
    Route::get('/notifications', [NotificationController::class, 'index']);
    Route::post('/notifications/{id}/read', [NotificationController::class, 'markAsRead']);
    Route::post('/notifications/read-all', [NotificationController::class, 'markAllAsRead']);
    Route::delete('/notifications/{id}', [NotificationController::class, 'destroy']);

    // Reports (User melapor)
    Route::post('/reports', [ReportController::class, 'store']);

    // ==========================================
    // 3. RUTE KHUSUS: ADMIN & MODERATOR
    // ==========================================
    Route::middleware('role:admin,moderator')->group(function () {
        // Categories (Store & Update)
        Route::post('categories', [CategoryController::class, 'store']);
        Route::put('categories/{id}', [CategoryController::class, 'update']);

        // Management Reports
        Route::get('/admin/reports', [ReportController::class, 'index']);
        Route::get('/admin/reports/{id}', [ReportController::class, 'show']);
        Route::put('/admin/reports/{id}', [ReportController::class, 'update']);

        // Dummy Route Test
        Route::post('threads/delete-palsu', function () {
            return response()->json(['message' => 'Thread berhasil deleted oleh Moderator/Admin.']);
        });
    });

    // route hanya khusus admin untuk manajemen tag, kategori, dan assign role pengguna
    Route::middleware('role:admin')->group(function () {
        // Tags Management
        Route::post('tags', [TagController::class, 'store']);
        Route::put('tags/{id}', [TagController::class, 'update']);
        Route::delete('tags/{id}', [TagController::class, 'destroy']);

        // Categories (Hanya Admin yang bisa delete)
        Route::delete('categories/{id}', [CategoryController::class, 'destroy']);

        // Rute Manajemen Peran Pengguna (Assign Role)
        Route::put('admin/users/{id}/assign-role', [AuthController::class, 'assignRole']);
    });
});
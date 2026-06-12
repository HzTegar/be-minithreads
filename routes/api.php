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

// Proteksi global untuk Login & Register (Maksimal 200 request per 1 menit)
Route::group(['prefix' => 'auth', 'middleware' => 'rate.limit:200,1'], function () {
    Route::post('register', [AuthController::class, 'register'])->name('auth.register');
    Route::post('login', [AuthController::class, 'login'])->name('auth.login');
});

// Proteksi global untuk fitur pencarian (Maksimal 200 request per 1 menit)
Route::group(['prefix' => 'search', 'middleware' => 'rate.limit:200,1'], function () {
    Route::get('global', [SearchController::class, 'searchGlobal'])->name('search.global');
    Route::get('posts', [SearchController::class, 'searchPosts'])->name('search.posts');
    Route::get('users', [SearchController::class, 'searchUsers'])->name('search.users');
    Route::get('tags', [SearchController::class, 'searchTags'])->name('search.tags');
    Route::get('categories', [SearchController::class, 'searchCategories'])->name('search.categories');
});

// Konten Publik Read-Only dengan kombinasi Cache dan Rate Limiter (Maksimal 200 request per 1 menit)
Route::group(['middleware' => 'rate.limit:200,1'], function () {
    Route::get('posts', [PostController::class, 'index'])->middleware('cache.response:250')->name('posts.index');
    Route::get('posts/{id}', [PostController::class, 'show'])->middleware('cache.response:250')->name('posts.show');

    Route::get('tags', [TagController::class, 'index'])->middleware('cache.response:250')->name('tags.index');
    Route::get('tags/{id}', [TagController::class, 'show'])->middleware('cache.response:250')->name('tags.show');

    Route::get('categories', [CategoryController::class, 'index'])->middleware('cache.response:250')->name('categories.index');
    Route::get('categories/{id}', [CategoryController::class, 'show'])->middleware('cache.response:250')->name('categories.show');
});


// ==========================================
// 2. RUTE PROTECTED (Wajib Login JWT)
// ==========================================

Route::middleware(['auth:api', 'rate.limit:200,1'])->group(function () {
    
    // Auth & Profile
    Route::group(['prefix' => 'auth'], function () {
        Route::get('me', [AuthController::class, 'me'])->name('auth.me');
        Route::post('logout', [AuthController::class, 'logout'])->name('auth.logout');
        Route::get('admin/dashboard', [AuthController::class, 'dashboard'])->name('auth.dashboard');
    });
    
    Route::post('profile/update', [ProfileController::class, 'updateProfile'])->name('profile.update');

    // Bookmarks
    Route::get('/bookmarks', [BookmarkController::class, 'index'])->name('bookmarks.index');
    Route::post('/posts/{postId}/bookmark', [BookmarkController::class, 'toggle'])->name('bookmarks.toggle');

    // Posts Management
    Route::post('posts', [PostController::class, 'store'])->middleware('rate.limit:200,1')->name('posts.store');
    Route::put('posts/{id}', [PostController::class, 'update'])->name('posts.update');
    Route::delete('posts/{id}', [PostController::class, 'destroy'])->name('posts.destroy');
    Route::get('/posts/{id}/history', [PostController::class, 'viewHistory'])->name('posts.history');
    Route::post('/posts/{id}/toggle-archive', [PostController::class, 'toggleArchive'])->name('posts.archive');
    Route::post('/posts/{postId}/comments/{commentId}/toggle-accepted', [PostController::class, 'toggleAcceptedAnswer'])->name('posts.accepted');

    // Tags Management (Bisa dibuat oleh siapa saja yang penting sudah login)
    Route::post('tags', [TagController::class, 'store'])->name('tags.store');

    // Social & Interactions
    Route::post('user/follow/{id}', [FollowController::class, 'toggleFollow'])->middleware('rate.limit:200,1')->name('user.follow');
    Route::post('/vote', [VoteController::class, 'handleVote'])->middleware('rate.limit:200,1')->name('vote');
    Route::post('/like', [LikeController::class, 'handleLike'])->middleware('rate.limit:200,1')->name('like');

    // Comments Management
    Route::post('/posts/{postId}/comments', [CommentController::class, 'store'])->middleware('rate.limit:200,1')->name('comments.store');
    Route::put('/comments/{id}', [CommentController::class, 'update'])->name('comments.update');
    Route::delete('/comments/{id}', [CommentController::class, 'destroy'])->name('comments.destroy');
    Route::get('/comments/{id}/history', [CommentController::class, 'viewHistory'])->name('comments.history');
    Route::post('/comments/{id}/like', [CommentController::class, 'toggleLike'])->middleware('rate.limit:200,1')->name('comments.like');

    // Notifications
    Route::get('/notifications', [NotificationController::class, 'index'])->name('notifications.index');
    Route::post('/notifications/{id}/read', [NotificationController::class, 'markAsRead'])->name('notifications.read');
    Route::post('/notifications/read-all', [NotificationController::class, 'markAllAsRead'])->name('notifications.read-all');
    Route::delete('/notifications/{id}', [NotificationController::class, 'destroy'])->name('notifications.destroy');

    // Reports
    Route::post('/reports', [ReportController::class, 'store'])->name('reports.store');

    // ==========================================
    // 3. RUTE KHUSUS: ADMIN & MODERATOR
    // ==========================================
    Route::middleware('role:admin,moderator')->group(function () {
        Route::post('categories', [CategoryController::class, 'store'])->name('admin.categories.store');
        Route::put('categories/{id}', [CategoryController::class, 'update'])->name('admin.categories.update');

        Route::get('/admin/reports', [ReportController::class, 'index'])->name('admin.reports.index');
        Route::get('/admin/reports/{id}', [ReportController::class, 'show'])->name('admin.reports.show');
        Route::put('/admin/reports/{id}', [ReportController::class, 'update'])->name('admin.reports.update');

        Route::post('threads/delete-palsu', function () {
            return response()->json(['message' => 'Thread berhasil deleted oleh Moderator/Admin.']);
        })->name('admin.threads.delete');
        
    });

    Route::middleware('role:admin')->group(function () {
        // Rute update & destroy tag tetap aman di sini (hanya untuk Admin)
        Route::put('tags/{id}', [TagController::class, 'update'])->name('admin.tags.update');
        Route::delete('tags/{id}', [TagController::class, 'destroy'])->name('admin.tags.destroy');

        Route::delete('categories/{id}', [CategoryController::class, 'destroy'])->name('admin.categories.destroy');

        // Fix Typo Kecil 'pref ix' yang ada di script bawaan awal
        Route::put('admin/users/{id}/assign-role', [AuthController::class, 'assignRole'])->name('admin.users.role');
    });
});
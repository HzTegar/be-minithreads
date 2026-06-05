<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Post;
use App\Models\Comment;
use App\Services\ReputationService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

class PostController extends Controller
{
    /**
     * 1. GET ALL POSTS WITH FILTER & PAGINATION (READ - INDEX)
     * Mengambil data postingan terbaru dengan dukungan filter category_id, user_id, dan tag (slug atau ID)
     */
    public function index(Request $request)
    {
        // Inisialisasi query dasar, dimuat dengan relasi, dan diurutkan dari yang terbaru
        $query = Post::with(['user', 'category', 'comments', 'tags'])->latest();

        // Terapkan filter hanya jika parameter benar-benar diisi di URL (Query Params)
        if ($request->filled('category_id')) {
            $query->where('category_id', $request->category_id);
        }

        if ($request->filled('user_id')) {
            $query->where('user_id', $request->user_id);
        }

        if ($request->filled('tag')) {
            $query->whereHas('tags', function ($q) use ($request) {
                $q->where('slug', $request->tag)->orWhere('id', $request->tag);
            });
        }

        // Eksekusi pagination (10 item per halaman)
        $posts = $query->paginate(10);

        // Penentuan pesan dinamis berdasarkan keberadaan filter di Query Params
        $isFiltered = $request->filled('category_id') || $request->filled('user_id') || $request->filled('tag');

        $message = $isFiltered 
            ? "Daftar postingan berdasarkan filter berhasil diambil, bro!" 
            : "Daftar semua postingan berhasil diambil, bro!";

        return response()->json([
            'success' => true,
            'message' => $message,
            'data' => $posts
        ], 200);
    }

    /**
     * 2. GET SINGLE POST BY ID (READ - SHOW)
     * Mengambil detail satu postingan berdasarkan ID UUID beserta daftar komentar
     */
    public function show($id)
    {
        $user = auth('api')->user();
        $isAdminOrModerator = $user && ($user->isAdmin() || $user->isModerator());

        // Inisialisasi query dasar
        $query = Post::with([
            'user', 
            'category', 
            'tags', 
            'comments' => function($q) use ($isAdminOrModerator) {
                $q->whereNull('parent_id')
                  ->with(['user', 'replies' => function($rq) use ($isAdminOrModerator) {
                      if ($isAdminOrModerator) {
                          $rq->with('editHistories');
                      }
                  }]);
                
                if ($isAdminOrModerator) {
                    $q->with('editHistories');
                }

                $q->latest();
            }
        ]);

        if ($isAdminOrModerator) {
            $query->with('editHistories');
        }

        $post = $query->find($id);

        // Validasi jika postingan tidak ditemukan
        if (!$post) {
            return response()->json([
                'success' => false,
                'message' => 'Postingan tidak ditemukan.'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'Detail postingan berhasil ditemukan, bro!',
            'data'    => $post
        ], 200);
    }
    /**
     * 3. CREATE POST (STORE)
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'category_id' => 'required|exists:categories,id',
            'title'       => 'required|string|max:300',
            'body'        => 'required|string',
            'tags'        => 'nullable|array',
            'tags.*'      => 'string|max:50'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $user = auth('api')->user();
        
        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'Sesi login tidak valid atau kadaluarsa.'
            ], 401);
        }

        return DB::transaction(function () use ($request, $user) {
            $post = $user->posts()->create([
                'category_id' => $request->category_id,
                'title'       => $request->title,
                'slug'        => Str::slug($request->title) . '-' . Str::random(5),
                'body'        => $request->body,
                'status'      => 'open',
                'edit_count'  => 0,
            ]);

            // Menyinkronkan hubungan tags ke tabel pivot jika dikirimkan
            if ($request->has('tags')) {
                $tagIds = [];
                foreach ($request->tags as $tagName) {
                    $tag = \App\Models\Tag::firstOrCreate(
                        ['name' => $tagName],
                        ['slug' => Str::slug($tagName), 'color' => '#3B82F6']
                    );
                    $tagIds[] = $tag->id;
                }
                $post->tags()->sync($tagIds);
            }

            return response()->json([
                'success' => true,
                'message' => 'Pertanyaan kamu berhasil diterbitkan, bro!',
                'data'    => $post->load('tags') // Memuat tag yang baru ditempel agar muncul di response
            ], 201);
        });
    }

    /**
     * 4. EDIT POST (UPDATE)
     */
    public function update(Request $request, $id)
    {
        $post = Post::find($id);

        if (!$post) {
            return response()->json([
                'success' => false,
                'message' => 'Postingan tidak ditemukan.'
            ], 404);
        }

        $user = auth('api')->user();
        if (!$user || $user->id !== $post->user_id) {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak! Kamu bukan pemilik postingan ini, bro.'
            ], 403);
        }

        // Cek batasan edit (maksimal 3 kali)
        if ($post->edit_count >= 3) {
            return response()->json([
                'success' => false,
                'message' => 'Slot edit habis! Kamu hanya dibatasi mengedit postingan maksimal 3 kali, bro.'
            ], 400);
        }

        $validator = Validator::make($request->all(), [
            'category_id' => 'required|exists:categories,id',
            'title'       => 'required|string|max:300',
            'body'        => 'required|string',
            'tags'        => 'nullable|array',
            'tags.*'      => 'string|max:50'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        return DB::transaction(function () use ($request, $post) {
            // Log history sebelum diupdate
            $post->editHistories()->create([
                'old_title'   => $post->title,
                'new_title'   => $request->title,
                'old_body'    => $post->body,
                'new_body'    => $request->body,
                'edit_number' => $post->edit_count + 1,
            ]);

            $post->update([
                'category_id' => $request->category_id,
                'title'       => $request->title,
                'slug'        => Str::slug($request->title) . '-' . Str::random(5),
                'body'        => $request->body,
                'edit_count'  => $post->edit_count + 1,
            ]);

            if ($request->has('tags')) {
                $tagIds = [];
                foreach ($request->tags as $tagName) {
                    $tag = \App\Models\Tag::firstOrCreate(
                        ['name' => $tagName],
                        ['slug' => Str::slug($tagName), 'color' => '#3B82F6']
                    );
                    $tagIds[] = $tag->id;
                }
                $post->tags()->sync($tagIds);
            }

            return response()->json([
                'success' => true,
                'message' => 'Postingan berhasil diperbarui, bro!',
                'data'    => $post->load(['tags', 'editHistories'])
            ], 200);
        });
    }

    /**
     * 5. DELETE POST (DESTROY)
     */
    public function destroy($id)
    {
        $post = Post::withTrashed()->find($id);

        if (!$post) {
            return response()->json([
                'success' => false,
                'message' => 'Postingan tidak ditemukan.'
            ], 404);
        }

        $user = auth('api')->user();
        
        // Cek apakah Admin (Bisa Hard Delete)
        if ($user->isAdmin()) {
            $post->tags()->detach();
            $post->forceDelete(); // Hard delete fisik dari database
            return response()->json([
                'success' => true,
                'message' => 'Postingan berhasil dihapus PERMANEN oleh Admin, bro!'
            ], 200);
        }

        // Cek apakah Pemilik (Hanya bisa Soft Delete)
        if ($user->id === $post->user_id) {
            $post->tags()->detach();
            $post->delete(); // Soft delete (hanya isi deleted_at)
            return response()->json([
                'success' => true,
                'message' => 'Postingan berhasil dihapus (Soft Delete), bro!'
            ], 200);
        }

        return response()->json([
            'success' => false,
            'message' => 'Akses ditolak! Kamu tidak punya hak menghapus postingan ini.'
        ], 403);
    }

    /**
     * 6. TOGGLE ACCEPTED ANSWER
     */
    public function toggleAcceptedAnswer(Request $request, $postId, $commentId)
    {
        $post = Post::find($postId);
        $comment = Comment::with('user')->find($commentId);

        if (!$post || !$comment) {
            return response()->json([
                'success' => false,
                'message' => 'Post atau Komentar tidak ditemukan.'
            ], 404);
        }

        $user = auth('api')->user();
        if (!$user || $user->id !== $post->user_id) {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak! Cuma pemilik pertanyaan yang bisa milih jawaban terbaik, bro.'
            ], 403);
        }

        if ($comment->post_id !== $post->id) {
            return response()->json([
                'success' => false,
                'message' => 'Komentar ini bukan bagian dari postingan ini.'
            ], 400);
        }

        return DB::transaction(function () use ($post, $comment) {
            $oldAcceptedAnswerId = $post->accepted_answer_id;
            $service = app(ReputationService::class);

            // Kondisi Toggle Off: Membatal status jawaban terbaik yang sudah ada
            if ($oldAcceptedAnswerId === $comment->id) {
                $post->update(['accepted_answer_id' => null, 'is_answered' => false]);
                $comment->update(['is_accepted' => false]);

                if ($comment->user) {
                    $service->deductPoints(
                        $comment->user,
                        ReputationService::POINTS_ACCEPTED_ANSWER,
                        'accepted_answer_revoked',
                        $comment->id,
                        "Jawaban terbaik dicabut pada post: {$post->title}"
                    );
                }

                return response()->json([
                    'success' => true,
                    'message' => 'Status jawaban terbaik berhasil dicabut, bro.',
                    'data' => ['is_accepted' => false]
                ]);
            }

            // Kondisi Rebutan/Penggantian: Cabut poin dari jawaban terbaik lama (jika ada)
            if ($oldAcceptedAnswerId) {
                $oldComment = Comment::with('user')->find($oldAcceptedAnswerId);
                if ($oldComment) {
                    $oldComment->update(['is_accepted' => false]);
                    if ($oldComment->user) {
                        $service->deductPoints(
                            $oldComment->user,
                            ReputationService::POINTS_ACCEPTED_ANSWER,
                            'accepted_answer_replaced',
                            $oldComment->id,
                            "Jawaban terbaik digantikan pada post: {$post->title}"
                        );
                    }
                }
            }

            // Menetapkan jawaban baru sebagai yang terbaik
            $post->update(['accepted_answer_id' => $comment->id, 'is_answered' => true]);
            $comment->update(['is_accepted' => true]);

            if ($comment->user) {
                $service->awardPoints(
                    $comment->user,
                    ReputationService::POINTS_ACCEPTED_ANSWER,
                    'accepted_answer_received',
                    $comment->id,
                    "Selamat! Jawabanmu terpilih sebagai yang terbaik di: {$post->title}"
                );
            }

            return response()->json([
                'success' => true,
                'message' => 'Mantap! Jawaban terbaik berhasil dipilih.',
                'data' => ['is_accepted' => true]
            ]);
        });
    }
}
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
     * 1. GET ALL POSTS WITH FILTER (READ - INDEX)
     * Mengambil data postingan terbaru dengan dukungan filter category_id dan user_id beserta komentar
     */
    public function index(Request $request)
    {
        // Membuka base kueri beserta eager loading relasi (termasuk comments)
        $query = Post::with(['user', 'category', 'comments']);

        // Kondisional kueri: filter berdasarkan category_id jika dikirim di URL
        $query->when($request->filled('category_id'), function ($q) use ($request) {
            return $q->where('category_id', $request->category_id);
        });

        // Kondisional kueri: filter berdasarkan user_id jika dikirim di URL
        $query->when($request->filled('user_id'), function ($q) use ($request) {
            return $q->where('user_id', $request->user_id);
        });

        // Eksekusi data postingan terbaru
        $posts = $query->latest()->get();

        // Menentukan pesan response yang dinamis berdasarkan aksi filter
        $message = 'Daftar semua postingan berhasil diambil, bro!';
        if ($request->anyFilled(['category_id', 'user_id'])) {
            $message = 'Daftar postingan berdasarkan filter berhasil diambil, bro!';
        }

        return response()->json([
            'success' => true,
            'message' => $message,
            'data'    => $posts
        ], 200);
    }

    /**
     * 2. GET SINGLE POST BY ID (READ - SHOW)
     * Mengambil detail satu postingan berdasarkan ID UUID beserta daftar komentar
     */
    public function show($id)
    {
        // Menyertakan relasi 'comments' agar daftar komentar muncul pada detail postingan
        $post = Post::with(['user', 'category', 'comments'])->find($id);

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
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $user = auth('api')->user();

        $post = $user->posts()->create([
            'category_id' => $request->category_id,
            'title'       => $request->title,
            'slug'        => Str::slug($request->title) . '-' . Str::random(5),
            'body'        => $request->body,
            'status'      => 'open',
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Pertanyaan kamu berhasil diterbitkan, bro!',
            'data'    => $post
        ], 201);
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

        if (auth('api')->user()->id !== $post->user_id) {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak! Kamu bukan pemilik postingan ini, bro.'
            ], 403);
        }

        $validator = Validator::make($request->all(), [
            'category_id' => 'required|exists:categories,id',
            'title'       => 'required|string|max:300',
            'body'       => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $post->update([
            'category_id' => $request->category_id,
            'title'       => $request->title,
            'slug'        => Str::slug($request->title) . '-' . Str::random(5),
            'body'        => $request->body,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Postingan berhasil diperbarui, bro!',
            'data'    => $post
        ], 200);
    }

    /**
     * 5. DELETE POST (DESTROY)
     */
    public function destroy($id)
    {
        $post = Post::find($id);

        if (!$post) {
            return response()->json([
                'success' => false,
                'message' => 'Postingan tidak ditemukan.'
            ], 404);
        }

        if (auth('api')->user()->id !== $post->user_id) {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak! Kamu tidak punya hak menghapus postingan ini.'
            ], 403);
        }

        $post->delete();

        return response()->json([
            'success' => true,
            'message' => 'Postingan berhasil dihapus, bro!'
        ], 200);
    }

    /**
     * 6. TOGGLE ACCEPTED ANSWER
     */
    public function toggleAcceptedAnswer(Request $request, $postId, $commentId)
    {
        $post = Post::find($postId);
        $comment = Comment::find($commentId);

        if (!$post || !$comment) {
            return response()->json([
                'success' => false,
                'message' => 'Post atau Komentar tidak ditemukan.'
            ], 404);
        }

        // 1. Hanya Pemilik Pertanyaan yang Punya Remot
        if (auth('api')->user()->id !== $post->user_id) {
            return response()->json([
                'success' => false,
                'message' => 'Akses ditolak! Cuma pemilik pertanyaan yang bisa milih jawaban terbaik, bro.'
            ], 403);
        }

        // Pastikan komentar tersebut memang milik post tersebut
        if ($comment->post_id !== $post->id) {
            return response()->json([
                'success' => false,
                'message' => 'Komentar ini bukan bagian dari postingan ini.'
            ], 400);
        }

        return DB::transaction(function () use ($post, $comment) {
            $oldAcceptedAnswerId = $post->accepted_answer_id;
            $service = app(ReputationService::class);

            // Jika yang diklik adalah jawaban yang sudah accepted (Toggle Off/Batal)
            if ($oldAcceptedAnswerId === $comment->id) {
                $post->update(['accepted_answer_id' => null, 'is_answered' => false]);
                $comment->update(['is_accepted' => false]);

                // Efek Domino: Kurangi poin si penulis
                $service->deductPoints(
                    $comment->user,
                    ReputationService::POINTS_ACCEPTED_ANSWER,
                    'accepted_answer_revoked',
                    $comment->id,
                    "Jawaban terbaik dicabut pada post: {$post->title}"
                );

                return response()->json([
                    'success' => true,
                    'message' => 'Status jawaban terbaik berhasil dicabut, bro.',
                    'data' => ['is_accepted' => false]
                ]);
            }

            // Sistem Rebutan: Jika sebelumnya ada jawaban terbaik lain, cabut poinnya dulu
            if ($oldAcceptedAnswerId) {
                $oldComment = Comment::find($oldAcceptedAnswerId);
                if ($oldComment) {
                    $oldComment->update(['is_accepted' => false]);
                    $service->deductPoints(
                        $oldComment->user,
                        ReputationService::POINTS_ACCEPTED_ANSWER,
                        'accepted_answer_replaced',
                        $oldComment->id,
                        "Jawaban terbaik digantikan pada post: {$post->title}"
                    );
                }
            }

            // Set jawaban baru sebagai yang terbaik
            $post->update(['accepted_answer_id' => $comment->id, 'is_answered' => true]);
            $comment->update(['is_accepted' => true]);

            // Efek Domino: Beri poin si penulis baru
            $service->awardPoints(
                $comment->user,
                ReputationService::POINTS_ACCEPTED_ANSWER,
                'accepted_answer_received',
                $comment->id,
                "Selamat! Jawabanmu terpilih sebagai yang terbaik di: {$post->title}"
            );

            return response()->json([
                'success' => true,
                'message' => 'Mantap! Jawaban terbaik berhasil dipilih.',
                'data' => ['is_accepted' => true]
            ]);
        });
    }
}
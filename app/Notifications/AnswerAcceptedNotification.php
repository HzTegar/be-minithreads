<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\BroadcastMessage;
use Illuminate\Notifications\Notification;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;

class AnswerAcceptedNotification extends Notification implements ShouldBroadcast
{
    use Queueable;

    protected $post;
    protected $comment;
    protected $user;

    public function __construct($post, $comment, $user)
    {
        $this->post = $post;
        $this->comment = $comment;
        $this->user = $user;
    }

    public function via($notifiable): array
    {
        return ['database', 'broadcast'];
    }

    public function toArray($notifiable): array
    {
        return [
            'type' => 'answer_accepted',
            'user_id' => $this->user->id,
            'username' => $this->user->username,
            'post_id' => $this->post->id,
            'post_title' => $this->post->title,
            'comment_id' => $this->comment->id,
            'message' => "Selamat! Jawabanmu di postingan \"{$this->post->title}\" dipilih sebagai jawaban terbaik oleh {$this->user->username}.",
        ];
    }

    public function toBroadcast($notifiable): BroadcastMessage
    {
        return new BroadcastMessage([
            'type' => 'answer_accepted',
            'data' => $this->toArray($notifiable)
        ]);
    }
}

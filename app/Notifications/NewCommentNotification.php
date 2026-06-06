<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\BroadcastMessage;
use Illuminate\Notifications\Notification;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;

class NewCommentNotification extends Notification implements ShouldBroadcast
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
            'type' => 'new_comment',
            'user_id' => $this->user->id,
            'username' => $this->user->username,
            'post_id' => $this->post->id,
            'post_title' => $this->post->title,
            'comment_id' => $this->comment->id,
            'message' => "{$this->user->username} berkomentar di postinganmu: \"{$this->post->title}\"",
        ];
    }

    public function toBroadcast($notifiable): BroadcastMessage
    {
        return new BroadcastMessage([
            'type' => 'new_comment',
            'data' => $this->toArray($notifiable)
        ]);
    }
}

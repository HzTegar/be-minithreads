<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\BroadcastMessage;
use Illuminate\Notifications\Notification;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;

class CommentRepliedNotification extends Notification implements ShouldBroadcast
{
    use Queueable;

    protected $post;
    protected $reply;
    protected $user;

    public function __construct($post, $reply, $user)
    {
        $this->post = $post;
        $this->reply = $reply;
        $this->user = $user;
    }

    public function via($notifiable): array
    {
        return ['database', 'broadcast'];
    }

    public function toArray($notifiable): array
    {
        return [
            'type' => 'comment_reply',
            'user_id' => $this->user->id,
            'username' => $this->user->username,
            'post_id' => $this->post->id,
            'post_title' => $this->post->title,
            'reply_id' => $this->reply->id,
            'message' => "{$this->user->username} membalas komentarmu di postingan: \"{$this->post->title}\"",
        ];
    }

    public function toBroadcast($notifiable): BroadcastMessage
    {
        return new BroadcastMessage([
            'type' => 'comment_reply',
            'data' => $this->toArray($notifiable)
        ]);
    }
}

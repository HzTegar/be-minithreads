<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\BroadcastMessage;
use Illuminate\Notifications\Notification;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;

class PostVotedNotification extends Notification implements ShouldBroadcast
{
    use Queueable;

    protected $post;
    protected $user;

    public function __construct($post, $user)
    {
        $this->post = $post;
        $this->user = $user;
    }

    public function via($notifiable): array
    {
        return ['database', 'broadcast'];
    }

    public function toArray($notifiable): array
    {
        return [
            'type' => 'post_voted',
            'user_id' => $this->user->id,
            'username' => $this->user->username,
            'post_id' => $this->post->id,
            'post_title' => $this->post->title,
            'message' => "{$this->user->username} memberikan upvote pada postinganmu: \"{$this->post->title}\"",
        ];
    }

    public function toBroadcast($notifiable): BroadcastMessage
    {
        return new BroadcastMessage([
            'type' => 'post_voted',
            'data' => $this->toArray($notifiable)
        ]);
    }
}

<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Notification;

class ReportApprovedNotification extends Notification
{
    use Queueable;

    /**
     * Create a new notification instance.
     */
    public function __construct()
    {
        //
    }

    /**
     * Get the notification's delivery channels.
     */
    public function via(object $notifiable): array
    {
        return ['database'];
    }

    /**
     * Get the array representation of the notification.
     */
    public function toDatabase(object $notifiable): array
    {
        return [
            'title'   => 'Laporan Anda Telah Disetujui',
            'type'    => 'report_approved',
            'message' => 'Laporan yang Anda ajukan terhadap pelanggaran konten/user telah disetujui oleh tim moderator. Tindakan kompensasi dan penegakan kebijakan telah dilakukan sesuai aturan komunitas. Terima kasih atas kontribusi Anda!',
        ];
    }

    public function toArray(object $notifiable): array
    {
        return $this->toDatabase($notifiable);
    }
}
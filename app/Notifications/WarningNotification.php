<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Notification;

class WarningNotification extends Notification
{
    use Queueable;

    protected $moderatorNotes;

    /**
     * Create a new notification instance.
     */
    public function __construct($moderatorNotes)
    {
        // Menangkap catatan moderator yang dikirim dari ReportController
        $this->moderatorNotes = $moderatorNotes;
    }

    /**
     * Get the notification's delivery channels.
     */
    public function via(object $notifiable): array
    {
        // Mengubah channel pengiriman khusus ke Database
        return ['database'];
    }

    /**
     * Get the array representation of the notification.
     * Data di dalam sini akan otomatis disimpan ke kolom 'data' di database.
     */
    public function toDatabase(object $notifiable): array
    {
        return [
            'title'   => 'Peringatan Pelanggaran Konten',
            'type'    => 'warning',
            'message' => "Konten Anda terbukti melanggar aturan komunitas berdasarkan laporan pengguna. Poin reputasi Anda dikurangi sebesar 20 poin. Catatan Moderator: " . ($this->moderatorNotes ?? 'Tidak ada catatan spesifik.'),
        ];
    }

    /**
     * Fallback array representation (opsional, biarkan mengarah ke toDatabase)
     */
    public function toArray(object $notifiable): array
    {
        return $this->toDatabase($notifiable);
    }
}
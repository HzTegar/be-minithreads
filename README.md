# Mini Threads - Platform Forum & Diskusi Digital

Mini Threads adalah platform aplikasi forum diskusi interaktif berbasis API yang dirancang untuk mendukung pembuatan utas (posts), interaksi komentar bersarang, sistem penilaian konten (vote/like), akumulasi poin reputasi otomatis, hingga pencarian global instan.

---

## 👥 Detail Tim & Pembagian Kerja

**Ketua Tim:** Tito Tegar Pratama

### 🛠️ Backend Developer (Tito Tegar)
Bertanggung jawab penuh atas arsitektur basis data, keamanan sistem, penanganan performa, dan logika inti sistem API Mini Threads:
* **Autentikasi & Keamanan:** Mengimplementasikan Stateless Auth menggunakan **JWT Token** dan sistem pencegahan brute-force via **Rate Limiter** ketat pada rute krusial (Login & Register).
* **Optimasi & Cache:** Memasang sistem **Cache Response** pada konten publik read-only untuk meringankan beban pembacaan database.
* **Mesin Pencari (Search Engine):** Membangun **Instant Global Search** terkelompok yang responsif sejak ketikan 1 huruf pertama di 4 tabel sekaligus (Users, Categories, Tags, Posts).
* **Sistem Reputasi Otomatis:** Menyusun logika kalkulator poin (seperti +15 poin saat jawaban terpilih) dan sistem penentuan pangkat otomatis (*Reputation Level*).
* **Moderasi & Pelaporan:** Membuat sistem pelaporan konten (*Report System*) terintegrasi khusus untuk peran Admin dan Moderator.

### 🎨 Frontend Developer (Ridho)
Bertanggung jawab atas implementasi antarmuka pengguna (UI/UX), manajemen keadaan (*state*), dan integrasi komponen visual ke API:
* **Halaman Utama & CRUD Postingan:** Menyusun bodi tampilan postingan, membatasi slot pengubahan maksimal 3 kali, serta memunculkan label `"edited"` jika postingan pernah disunting.
* **Sistem Komentar & Reply:** Menampilkan antarmuka komentar bersarang (*nested response*), membatasi edit komentar maksimal 1 kali, dan menyematkan label `"edited"`.
* **Taksonomi & Profil:** Membuat komponen pembuatan tag baru, pemanfaatan opsi kategori yang tersedia, serta merancang halaman pembaruan data pengguna (*Edit Profile*).
* **Sistem Notifikasi:** Mengintegrasikan lonceng notifikasi *real-time* untuk menandai pesan masuk (*Mark as Read*).

---

## 📄 List Halaman Utama (Frontend Target)
1. **Halaman Register & Login** (Akses masuk sistem)
2. **Halaman Homepage / Dashboard Utama** (Daftar postingan terpopuler/terbaru dengan filter kategori)
3. **Halaman Detail Postingan** (Utas utama, riwayat sunting, dan kolom komentar bersarang)
4. **Halaman Profil Pengguna** (Bio, avatar, daftar bookmark, dan tingkat reputasi user)
5. **Halaman Manajemen Admin/Moderator** (Pemberian peran, pengelolaan tag, dan validasi laporan konten)

---

## 🚀 Fitur yang Selesai Dikerjakan (Backend Developer)

Berikut adalah daftar modul dan fitur backend yang telah selesai diimplementasikan secara penuh beserta fungsionalitasnya:

### 1. Autentikasi & Manajemen Pengguna
*   **Register dan Login (JWT Auth):** Sistem pendaftaran dan masuk akun aman berbasis token stateless (JSON Web Token).
*   **Multi-role Access Control:** Pembatasan hak akses berjenjang yang memisahkan otoritas antara Admin, Moderator, dan User biasa.
*   **Edit Profile:** API untuk memperbarui informasi profil pengguna, termasuk pengunggahan file gambar Avatar dan pengubahan teks Bio.
*   **Follow dan Unfollow User:** Fitur sosial yang memungkinkan pengguna untuk saling mengikuti antar-akun guna membangun jaringan relasi di dalam forum.
--
### 2. Manajemen Konten Utas (Post & Taksonomi)
*   **CRUD Postingan:** Otentikasi lengkap untuk membuat (Create), membaca (Read), menyunting (Update), dan menghapus (Delete) postingan utas.
*   **Tag dan Kategori:** Sistem pengelompokan konten. Admin & Moderator memiliki akses penuh untuk manajemen (CRUD), sedangkan hak hapus (Delete) dikunci khusus untuk peran Admin.
*   **Filter Postingan Dinamis:** API pencarian adaptif untuk menyaring daftar postingan berdasarkan kesamaan Tag, Kategori tertentu, atau dari User spesifik.
*   **Bookmark / Save Post:** Fitur bagi pengguna untuk menyimpan atau menandai postingan favorit agar dapat dibaca kembali di kemudian hari melalui daftar simpanan.
--
### 3. Solusi Pertanyaan & Pengujian Otomatis
*   **Mark as Accepted Answer (Single & Toggle Off):** Pemilik pertanyaan dapat menetapkan satu komentar terbaik sebagai solusi. Fitur ini mendukung sistem sakelar (Toggle Off) untuk membatalkan status jika solusi berubah, disertai proteksi hak akses ketat agar tidak bisa dimanipulasi oleh user lain.
*   **Automated Feature Test:** Pembuatan skrip pengujian otomatis (Testing) untuk memastikan seluruh alur logika fitur *Accepted Answer* berjalan normal tanpa adanya bug (*Full Passed*).
--
### 4. Sistem Riwayat & Log Audit (Edit History)
*   **Edit History Postingan:** Log pencatatan otomatis yang menyimpan riwayat perubahan teks lama ke teks baru setiap kali sebuah postingan diperbarui oleh pemiliknya.
*   **Edit History Komentar:** Sistem pelacakan serupa yang khusus merekam jejak perubahan teks dari aktivitas penyuntingan komentar.
--
### 5. Komentar Bersarang & Interaksi Konten
*   **Comments dan Reply (Nested):** Struktur komentar bersarang yang mendukung diskusi mendalam, di mana pengguna bisa membalas langsung komentar milik pengguna lain secara rapi.
*   **Edit dan Hapus Komentar:** Fitur pengubahan isi teks dan penghapusan komentar yang telah dikirimkan oleh pengguna.
*   **Upvote / Downvote Postingan & Komentar:** Sistem penilaian konten (*voting*) yang memungkinkan komunitas memberikan poin reputasi naik atau turun pada postingan maupun komentar yang dianggap berkualitas atau tidak layak.
--
### 6. Sistem Poin & Reputasi
*   **Automated Point System:** Akumulasi penambahan poin otomatis ke akun pengguna (misalnya, otomatis mendapatkan +15 poin saat komentarnya terpilih sebagai *Jawaban Terbaik*).
*   **Points Log:** Sistem pencatatan riwayat (log) mutasi poin untuk memantau dari mana saja sumber poin tersebut didapatkan secara transparan.

---

## 🛠️ Langkah Instalasi Backend (Lokal)

1. **Clone Repositori:**
   ```bash
   git clone [https://github.com/username/mini-threads.git](https://github.com/username/mini-threads.git)
   cd mini-threads
2. **Instalasi Dependency Composer:**
    composer install
3. **Konfigurasi Environment:**
    Salin file .env.example menjadi .env lalu sesuaikan pengaturan koneksi database MySQL :
    cp .env.example .env
4. **Pengaturan Driver (penting untuk cache & rate limiter):**
    Pastikan konfigurasi driver di dalam berkas .env sudah teratur seperti di bawah ini agar middleware pembatas request berjalan lancar :
    CACHE_STORE=file
    QUEUE_CONNECTION=sync
5. **Generate App Key & JWT Secret:**
    php artisan key:generate
    php artisan jwt:secret
6.  **Jalankan migration dan seeders**
    php artisan migrate --seed
7.  **Hubungkan Storage Link (wajib untuk fitur upload avatar profil):**
    php artisan storage:link
8.  **Nyalakan Server Lokal:**
    php artisan serve
    lalu nanti api dapat diakses secara lokal di route : http://127.0.0.1:8000/api/
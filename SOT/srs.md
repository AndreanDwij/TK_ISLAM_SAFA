# Software Requirements Specification (SRS)

# Sistem Informasi Penilaian dan Administrasi Siswa TK Islam Safa

---

# 1. Pendahuluan

## 1.1 Latar Belakang

TK Islam Safa masih melakukan proses administrasi penilaian siswa secara manual menggunakan buku penilaian, lembar observasi, dan dokumentasi foto yang tersimpan pada perangkat pribadi guru. Berdasarkan hasil wawancara dan observasi, proses tersebut menimbulkan berbagai kendala seperti keterlambatan pencatatan, pekerjaan administrasi yang menumpuk, kesulitan mencari kembali dokumentasi, serta lamanya penyusunan laporan perkembangan siswa.

Sistem Informasi Penilaian dan Administrasi Siswa dikembangkan untuk mendigitalisasi seluruh proses penilaian sehingga guru dapat melakukan pencatatan secara langsung menggunakan perangkat mobile, menyimpan dokumentasi perkembangan dalam satu sistem, dan menghasilkan laporan perkembangan secara otomatis.

---

## 1.2 Tujuan Sistem

Sistem memiliki tujuan sebagai berikut.

- Membantu guru melakukan penilaian siswa secara digital.
- Mengurangi penggunaan pencatatan manual menggunakan kertas.
- Mengintegrasikan data siswa, penilaian, dokumentasi, dan laporan dalam satu sistem.
- Mempermudah kepala sekolah memonitor perkembangan siswa.
- Mempermudah orang tua memperoleh laporan perkembangan anak.
- Mempercepat proses penyusunan laporan perkembangan siswa.
- Mengurangi risiko kehilangan data penilaian.

---

# 2. Ruang Lingkup Sistem

Sistem hanya digunakan untuk proses administrasi penilaian siswa TK Islam Safa.

Ruang lingkup sistem meliputi:

- Login pengguna
- Dashboard
- Pengelolaan data siswa
- Pengelolaan penilaian
- Dokumentasi perkembangan siswa
- Riwayat perkembangan
- Pembuatan laporan
- Monitoring perkembangan siswa
- Profil pengguna

Sistem tidak mencakup pembayaran, presensi, komunikasi orang tua, maupun fitur pembelajaran daring.

---

# 3. Aktor Sistem

## Guru

Deskripsi

Guru merupakan pengguna utama sistem yang bertanggung jawab melakukan seluruh proses administrasi penilaian siswa.

Hak akses

- Login
- Logout
- Mengubah profil
- Melihat dashboard
- Menambah data siswa
- Mengubah data siswa
- Menghapus data siswa
- Melihat data siswa
- Menambah penilaian
- Mengubah penilaian
- Menghapus penilaian
- Mengunggah dokumentasi
- Menghapus dokumentasi
- Melihat riwayat perkembangan
- Generate laporan
- Cetak laporan

---

## Kepala Sekolah

Deskripsi

Kepala sekolah bertugas melakukan monitoring perkembangan siswa berdasarkan laporan yang telah dibuat guru.

Hak akses

- Login
- Logout
- Dashboard
- Melihat statistik perkembangan
- Melihat laporan
- Mencetak laporan

---

## Orang Tua

Deskripsi

Orang tua hanya memiliki akses terhadap laporan perkembangan anaknya.

Hak akses

- Login
- Logout
- Melihat laporan perkembangan
- Mengunduh laporan PDF

---

# 4. Tech Stack

Frontend

- React Native (Expo)
- TypeScript

Backend

- Express.js

Database

- PostgreSQL

Authentication

- JWT Authentication

Storage

- Firebase Storage

State Management

- Redux Toolkit

API

- REST API

---

# 5. Functional Requirements

FR-001

Sistem harus menyediakan halaman login.

FR-002

Sistem harus melakukan validasi email dan password.

FR-003

Sistem harus menyimpan sesi login pengguna.

FR-004

Guru dapat menambahkan data siswa.

FR-005

Guru dapat mengubah data siswa.

FR-006

Guru dapat menghapus data siswa.

FR-007

Guru dapat melihat seluruh data siswa.

FR-008

Guru dapat mencari data siswa.

FR-009

Guru dapat menambahkan penilaian.

FR-010

Guru dapat mengubah penilaian.

...

FR-030

Orang tua dapat melihat laporan perkembangan anak.

---

# 6. Non Functional Requirements

Performance

- Respon aplikasi maksimal 3 detik.

Availability

- Sistem tersedia 24 jam.

Usability

- Antarmuka sederhana dan mudah digunakan guru.

Security

- Password harus terenkripsi.
- JWT wajib digunakan.
- Session login memiliki batas waktu.

Compatibility

- Android minimal versi 9.
- iOS minimal versi 15.

---

# 7. In Scope Features

- Login
- Logout
- Dashboard
- CRUD Siswa
- CRUD Penilaian
- Upload Dokumentasi
- Riwayat Perkembangan
- Generate Laporan
- Dashboard Monitoring
- Profil

---

# 8. Out of Scope

- Chat
- Video
- Payment
- Presensi
- AI Penilaian
- WhatsApp
- Push Notification

---

# 9. Business Rules

1. Guru wajib login.
2. Penilaian harus memiliki siswa.
3. Setiap penilaian memiliki tanggal.
4. Foto harus terhubung dengan penilaian.
5. Kepala sekolah tidak boleh mengubah data.
6. Orang tua hanya melihat laporan anaknya.
7. Data siswa yang memiliki penilaian tidak boleh dihapus.
8. Laporan hanya dapat dibuat jika terdapat penilaian.
9. Semua perubahan langsung tersimpan ke database.
10. Laporan dibuat otomatis berdasarkan seluruh data penilaian.

---

# 10. Asumsi

- Seluruh guru memiliki akun.
- Sekolah memiliki koneksi internet.
- Guru menggunakan smartphone Android.

---

# 11. Constraint

- Maksimal ukuran foto 5 MB.
- Format foto JPG dan PNG.
- Maksimal upload 10 foto setiap penilaian.
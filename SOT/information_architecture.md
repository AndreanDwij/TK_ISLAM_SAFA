# Information Architecture

# Sistem Informasi Penilaian dan Administrasi Siswa TK Islam Safa

---

# 1. Tujuan Information Architecture

Dokumen ini menjelaskan struktur informasi, navigasi aplikasi, hubungan antar halaman, alur perpindahan pengguna, serta organisasi seluruh fitur yang tersedia dalam Sistem Informasi Penilaian dan Administrasi Siswa TK Islam Safa.

Information Architecture digunakan sebagai Source of Truth untuk implementasi halaman, navigasi, routing, dan struktur aplikasi sehingga seluruh pengembangan frontend memiliki struktur yang konsisten.

---

# 2. Platform

Platform utama

- Mobile Android
- Mobile iOS

Framework

- React Native (Expo)

Orientasi

- Portrait

Minimum Screen Width

- 360 px

---

# 3. Global Navigation

Aplikasi menggunakan Bottom Navigation dengan lima menu utama.

Bottom Navigation

🏠 Beranda

👦 Siswa

📝 Penilaian

📄 Laporan

👤 Profil

Halaman login tidak menggunakan Bottom Navigation.

---

# 4. Sitemap

Splash Screen

↓

Login

↓

Dashboard

├── Data Siswa
│
│ ├── Daftar Siswa
│ ├── Detail Siswa
│ ├── Tambah Siswa
│ ├── Edit Siswa
│ └── Hapus Siswa
│
├── Penilaian
│
│ ├── Daftar Penilaian
│ ├── Tambah Penilaian
│ ├── Detail Penilaian
│ ├── Edit Penilaian
│ └── Hapus Penilaian
│
├── Dokumentasi
│
│ ├── Daftar Dokumentasi
│ ├── Upload Dokumentasi
│ ├── Detail Dokumentasi
│ └── Hapus Dokumentasi
│
├── Laporan
│
│ ├── Daftar Laporan
│ ├── Detail Laporan
│ ├── Generate Laporan
│ └── Export PDF
│
└── Profil
    ├── Edit Profil
    ├── Ganti Password
    ├── Tentang Aplikasi
    └── Logout

---

# 5. Struktur Halaman

## Splash Screen

Tujuan

Menampilkan identitas aplikasi saat pertama kali dibuka.

Komponen

- Logo TK Islam Safa
- Nama aplikasi
- Loading Indicator

Navigasi

Jika token login tersedia

→ Dashboard

Jika token tidak tersedia

→ Login

---

## Login

Tujuan

Melakukan autentikasi pengguna.

Komponen

- Logo
- Email
- Password
- Tombol Login
- Lupa Password (Nonaktif)
- Loading Indicator

Output

Dashboard

---

## Dashboard

Tujuan

Menampilkan ringkasan informasi utama.

Komponen

- Greeting
- Total Siswa
- Total Penilaian Hari Ini
- Total Dokumentasi
- Shortcut Menu
- Riwayat Aktivitas

Navigasi

→ Data Siswa

→ Penilaian

→ Laporan

→ Profil

---

## Data Siswa

Tujuan

Mengelola seluruh data siswa.

Komponen

- Search Bar
- Filter Kelas
- List Siswa
- Floating Action Button
- Pull to Refresh

Navigasi

Tambah Siswa

Detail Siswa

Edit Siswa

Hapus Siswa

---

## Detail Siswa

Komponen

- Foto Profil
- Biodata
- Riwayat Penilaian
- Dokumentasi
- Tombol Edit
- Tombol Hapus

---

## Penilaian

Komponen

- Search
- Filter Semester
- Filter Kelas
- List Penilaian
- FAB Tambah Penilaian

Navigasi

Tambah Penilaian

Detail Penilaian

Edit Penilaian

---

## Tambah Penilaian

Komponen

- Pilih Siswa
- Pilih Aspek Penilaian
- Nilai
- Catatan Guru
- Upload Foto
- Tombol Simpan

Output

Data Penilaian tersimpan.

---

## Dokumentasi

Komponen

- Gallery View
- Filter
- Kamera
- Upload
- Preview

---

## Laporan

Komponen

- Pilih Semester
- Pilih Siswa
- Generate
- Preview PDF
- Download PDF

---

## Profil

Komponen

- Foto
- Nama
- Email
- Edit Profil
- Ganti Password
- Logout

---

# 6. Navigation Rules

1. Pengguna wajib login sebelum mengakses Dashboard.

2. Bottom Navigation hanya muncul setelah login.

3. Tombol Back selalu kembali ke halaman sebelumnya.

4. Logout akan menghapus session.

5. Setelah logout pengguna diarahkan ke Login.

---

# 7. Entry Point

Splash Screen

↓

Login

↓

Dashboard

---

# 8. Exit Point

Logout

↓

Login

---

# 9. Screen Relationship

Splash

↓

Login

↓

Dashboard

↓

Data Siswa

↓

Detail Siswa

↓

Tambah Penilaian

↓

Generate Laporan

↓

Dashboard

---

# 10. Permission Navigation

Guru

- Dashboard
- Siswa
- Penilaian
- Dokumentasi
- Laporan
- Profil

Kepala Sekolah

- Dashboard
- Monitoring
- Laporan
- Profil

Orang Tua

- Dashboard
- Laporan Anak
- Profil

---

# 11. Search & Filter

Data Siswa

Filter

- Nama
- Kelas
- Jenis Kelamin

Penilaian

Filter

- Semester
- Tahun
- Guru

Dokumentasi

Filter

- Tanggal
- Nama Siswa

Laporan

Filter

- Semester
- Tahun Ajaran

---

# 12. Error Navigation

Session habis

↓

Login

Data tidak ditemukan

↓

Empty State

Server Error

↓

Error Screen

Internet mati

↓

Offline Notice

---

# 13. Future Navigation

Versi berikutnya akan mendukung:

- Push Notification
- Kalender Akademik
- Chat Orang Tua
- Presensi
- Backup Cloud
# User Flow Index

# Sistem Informasi Penilaian dan Administrasi Siswa TK Islam Safa

Version : 1.0

Document Status : Final

Author : Kelompok 7

Last Updated : 2026

---

# 1. Pendahuluan

Dokumen ini merupakan indeks utama seluruh User Flow pada Sistem Informasi Penilaian dan Administrasi Siswa TK Islam Safa.

Seluruh dokumen User Flow berfungsi sebagai Source of Truth (SoT) yang menjelaskan interaksi pengguna dengan sistem. Setiap User Flow berisi langkah penggunaan aplikasi, respons sistem, kondisi alternatif, kondisi pengecualian (exception), validasi, post-condition, serta acceptance criteria yang akan digunakan sebagai acuan implementasi frontend prototype.

Dokumen ini harus dibaca sebelum membaca dokumen User Flow lainnya.

---

# 2. Tujuan

Tujuan penyusunan User Flow adalah:

- Menjelaskan alur penggunaan aplikasi bagi setiap aktor.
- Menjadi acuan implementasi interaksi pengguna.
- Menjaga konsistensi perilaku aplikasi.
- Mengurangi ambiguitas selama proses pengembangan.
- Menjadi Source of Truth implementasi frontend.

---

# 3. Aktor

Aplikasi memiliki tiga aktor utama.

## Guru

Guru bertugas mengelola seluruh proses administrasi penilaian siswa.

Hak akses:

- Login
- Dashboard
- Kelola Data Siswa
- Input Penilaian
- Upload Dokumentasi
- Generate Laporan
- Edit Profil
- Logout

---

## Kepala Sekolah

Hak akses:

- Login
- Dashboard Monitoring
- Melihat Statistik
- Melihat Laporan
- Logout

---

## Orang Tua

Hak akses:

- Login
- Dashboard
- Melihat Laporan Anak
- Download PDF
- Logout

---

# 4. Daftar User Flow

| ID | Nama User Flow | Aktor | Prioritas |
|----|----------------|--------|-----------|
| UC-001 | Login | Guru, Kepala Sekolah, Orang Tua | Tinggi |
| UC-002 | Kelola Data Siswa | Guru | Tinggi |
| UC-003 | Input Penilaian | Guru | Tinggi |
| UC-004 | Upload Dokumentasi | Guru | Tinggi |
| UC-005 | Generate Laporan | Guru | Tinggi |
| UC-006 | Monitoring Perkembangan | Kepala Sekolah | Sedang |
| UC-007 | Melihat Laporan Anak | Orang Tua | Sedang |
| UC-008 | Edit Profil | Semua Aktor | Rendah |
| UC-009 | Logout | Semua Aktor | Tinggi |

---

# 5. Urutan Implementasi

Implementasi User Flow dilakukan dengan urutan berikut:

1. Login
2. Dashboard
3. Kelola Data Siswa
4. Input Penilaian
5. Upload Dokumentasi
6. Generate Laporan
7. Monitoring Perkembangan
8. Melihat Laporan Anak
9. Edit Profil
10. Logout

Urutan implementasi mengikuti prioritas kebutuhan utama sistem.

---

# 6. Aturan Implementasi

Seluruh implementasi User Flow harus mengikuti aturan berikut:

1. Seluruh User Flow mengacu pada SRS sebagai Source of Truth utama.

2. Tidak diperbolehkan membuat fitur baru di luar SRS.

3. Jika backend belum tersedia maka gunakan Local Storage atau Dummy Data.

4. Semua validasi harus mengikuti Business Rules pada SRS.

5. Semua proses yang memerlukan waktu harus menampilkan Loading Indicator.

6. Seluruh pesan kesalahan harus menggunakan Dialog atau Snackbar.

7. Setelah proses berhasil sistem wajib memberikan notifikasi kepada pengguna.

8. Semua data yang berhasil disimpan harus langsung muncul pada halaman terkait.

---

# 7. Validasi Umum

Validasi yang berlaku pada seluruh User Flow:

- Field wajib tidak boleh kosong.
- Email harus memiliki format yang benar.
- Password minimal 8 karakter.
- Foto maksimal 5 MB.
- Format foto hanya JPG, PNG, atau WEBP.
- Nama siswa minimal 3 karakter.
- Data tidak boleh duplikat.
- Session login harus valid.

---

# 8. Notifikasi Sistem

Jenis notifikasi yang digunakan:

Success

- Data berhasil disimpan.
- Data berhasil diperbarui.
- Data berhasil dihapus.

Warning

- Data belum lengkap.
- Tidak ada data ditemukan.

Error

- Gagal menyimpan data.
- Gagal memuat data.
- Server tidak dapat dihubungi.

---

# 9. Daftar Dokumen User Flow

Folder user_flows terdiri dari:

user_flows/

├── index.md

├── userflow_uc_001_login.md

├── userflow_uc_002_kelola_data_siswa.md

├── userflow_uc_003_input_penilaian.md

├── userflow_uc_004_upload_dokumentasi.md

├── userflow_uc_005_generate_laporan.md

├── userflow_uc_006_monitoring_perkembangan.md

├── userflow_uc_007_melihat_laporan.md

├── userflow_uc_008_edit_profil.md

└── userflow_uc_009_logout.md

---

# 10. Acceptance Criteria Global

Prototype dianggap selesai apabila:

- Pengguna dapat Login.
- Pengguna dapat Logout.
- Guru dapat mengelola data siswa.
- Guru dapat menginput penilaian.
- Guru dapat mengunggah dokumentasi.
- Guru dapat menghasilkan laporan perkembangan.
- Kepala sekolah dapat melakukan monitoring perkembangan siswa.
- Orang tua dapat melihat laporan perkembangan anak.
- Seluruh halaman dapat dinavigasikan tanpa error.
- Seluruh data dapat disimpan menggunakan Local Storage atau Dummy Data apabila backend belum tersedia.

---

# 11. Catatan

Apabila terdapat konflik antara User Flow dengan dokumen lain, maka implementasi mengikuti prioritas Source of Truth yang telah ditetapkan pada proyek.

Segala asumsi implementasi yang tidak dijelaskan pada dokumen ini harus dicatat pada IMPLEMENTATION_NOTES.md.
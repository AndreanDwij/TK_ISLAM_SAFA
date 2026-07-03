# UC-001 Login

## Tujuan

Melakukan autentikasi pengguna sebelum menggunakan aplikasi.

---

## Aktor

- Guru
- Kepala Sekolah
- Orang Tua

---

## Trigger

Pengguna membuka aplikasi.

---

## Pre-condition

- Pengguna memiliki akun.
- Aplikasi terhubung ke internet.

---

## Main Flow

1. Pengguna membuka aplikasi.
2. Splash Screen ditampilkan.
3. Sistem mengecek token login.
4. Jika tidak ada token maka Login ditampilkan.
5. Pengguna mengisi email.
6. Pengguna mengisi password.
7. Pengguna menekan tombol Login.
8. Sistem melakukan validasi.
9. Sistem memverifikasi akun.
10. Dashboard ditampilkan.

---

## Alternative Flow

Email kosong.

Password kosong.

Password salah.

Email tidak ditemukan.

---

## Exception Flow

Internet mati.

Server tidak dapat diakses.

Session gagal dibuat.

---

## Post Condition

Pengguna berhasil masuk ke Dashboard.

---

## Acceptance Criteria

✓ Login berhasil.

✓ Dashboard tampil.

✓ Session tersimpan.

✓ Error muncul jika gagal login.
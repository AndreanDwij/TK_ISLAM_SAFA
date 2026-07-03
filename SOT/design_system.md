# Design System

# Sistem Informasi Penilaian dan Administrasi Siswa TK Islam Safa

---

# 1. Tujuan Design System

Design System merupakan pedoman visual yang digunakan dalam pengembangan aplikasi Sistem Informasi Penilaian dan Administrasi Siswa TK Islam Safa.

Dokumen ini menjadi Source of Truth untuk memastikan seluruh halaman memiliki tampilan yang konsisten, mudah digunakan, serta sesuai dengan kebutuhan guru, kepala sekolah, dan orang tua.

---

# 2. Design Principles

Aplikasi dibangun berdasarkan prinsip berikut:

### Simple

Antarmuka dibuat sederhana sehingga guru dapat menggunakan aplikasi tanpa memerlukan pelatihan khusus.

### Consistent

Setiap halaman memiliki tata letak, warna, ikon, dan komponen yang konsisten.

### Accessible

Semua teks mudah dibaca dengan ukuran yang cukup besar dan memiliki kontras warna yang baik.

### Efficient

Fitur utama dapat diakses maksimal dalam tiga kali sentuhan.

### Responsive

Seluruh komponen menyesuaikan berbagai ukuran layar smartphone.

---

# 3. Color Palette

## Primary

Hijau

HEX : #16A34A

Digunakan untuk

- Tombol utama
- App Bar
- Bottom Navigation aktif
- Progress
- Link aktif

---

## Secondary

HEX : #22C55E

Digunakan untuk

- Badge
- Card Highlight
- Floating Action Button

---

## Background

HEX : #F8FAFC

Digunakan sebagai background utama aplikasi.

---

## Surface

HEX : #FFFFFF

Digunakan pada Card, Dialog, Modal, dan Bottom Sheet.

---

## Text Primary

HEX : #1F2937

Untuk judul dan isi.

---

## Text Secondary

HEX : #6B7280

Untuk deskripsi.

---

## Border

HEX : #E5E7EB

Untuk border card dan input.

---

## Success

HEX : #15803D

Status berhasil.

---

## Warning

HEX : #FACC15

Status peringatan.

---

## Error

HEX : #DC2626

Status gagal.

---

## Info

HEX : #3B82F6

Informasi umum.

---

# 4. Typography

Font Family

Inter

Fallback

Roboto

---

## Heading

H1

36 px

Bold

H2

30 px

Bold

H3

24 px

SemiBold

H4

20 px

SemiBold

H5

18 px

Medium

---

## Body

Body Large

16 px

Regular

Body Medium

14 px

Regular

Body Small

12 px

Regular

---

## Caption

12 px

Regular

---

# 5. Spacing System

Base Unit

4 px

Spacing

4 px

8 px

12 px

16 px

20 px

24 px

32 px

40 px

48 px

64 px

---

# 6. Border Radius

Small

8 px

Medium

12 px

Large

16 px

Extra Large

24 px

Circle

999 px

---

# 7. Shadow

Small

Card biasa.

Medium

Dialog.

Large

Bottom Sheet.

---

# 8. Layout

Safe Area digunakan pada seluruh halaman.

Margin Horizontal

16 px

Margin Vertical

16 px

Card Padding

16 px

Section Spacing

24 px

---

# 9. App Bar

Komponen

- Judul Halaman
- Tombol Back
- Tombol Notifikasi (opsional)

Background

Primary Green

Text

White

Elevation

2 dp

---

# 10. Bottom Navigation

Jumlah menu maksimal lima.

Menu

- Beranda
- Siswa
- Penilaian
- Laporan
- Profil

Icon aktif menggunakan warna Primary.

Icon tidak aktif menggunakan warna abu-abu.

---

# 11. Floating Action Button

Warna

Primary

Icon

Tambah (+)

Digunakan pada

- Tambah Siswa
- Tambah Penilaian
- Tambah Dokumentasi

Posisi

Kanan bawah.

---

# 12. Button

Primary Button

Background

Primary Green

Text

White

Radius

12 px

Height

48 px

---

Secondary Button

Background

White

Border

Primary Green

Text

Primary Green

---

Danger Button

Background

Merah

Text

Putih

---

Disabled Button

Background

Abu-abu

Text

Putih

---

# 13. Text Field

Komponen

- Label
- Placeholder
- Helper Text
- Error Message

Radius

10 px

Border

1 px

Focus

Hijau

Error

Merah

---

# 14. Dropdown

Digunakan pada

- Pilih Kelas
- Pilih Semester
- Pilih Siswa
- Pilih Guru

---

# 15. Search Bar

Komponen

- Icon Search
- Placeholder
- Clear Button

Digunakan pada

- Data Siswa
- Penilaian
- Dokumentasi
- Laporan

---

# 16. Card

Radius

16 px

Padding

16 px

Shadow

Medium

Isi Card

- Judul
- Deskripsi
- Status
- Tombol Aksi

---

# 17. List Item

Digunakan pada daftar siswa dan daftar penilaian.

Isi

- Foto
- Nama
- Deskripsi
- Icon Arrow

---

# 18. Table

Digunakan pada halaman laporan.

Header

Hijau

Body

Putih

Hover

Hijau muda

---

# 19. Dialog

Jenis

- Konfirmasi Hapus
- Logout
- Berhasil
- Gagal

Button

Ya

Batal

---

# 20. Bottom Sheet

Digunakan untuk

- Pilih Foto
- Pilih Kamera
- Pilih Semester

---

# 21. Snackbar

Durasi

3 detik

Digunakan untuk

- Berhasil menyimpan
- Berhasil menghapus
- Berhasil memperbarui

---

# 22. Loading State

Menggunakan Circular Progress Indicator.

Loading muncul ketika:

- Login
- Simpan Data
- Upload Foto
- Generate Laporan

---

# 23. Empty State

Ilustrasi kosong.

Pesan

"Belum ada data."

Tombol

Tambah Data

---

# 24. Error State

Icon Error

Warna Merah

Pesan

"Gagal memuat data."

Tombol

Coba Lagi

---

# 25. Icon System

Menggunakan Material Icons.

Icon utama

Home

Person

School

Assessment

Description

Camera

Logout

Edit

Delete

Save

Search

Print

Download

Upload

---

# 26. Image Rules

Format

JPG

PNG

WEBP

Ukuran maksimal

5 MB

Preview sebelum upload.

---

# 27. Animation

Menggunakan animasi sederhana.

Fade

Slide

Scale

Durasi maksimal

300 ms

---

# 28. Responsive Rules

Minimal lebar layar

360 px

Maksimal

Tablet 768 px

Layout mengikuti ukuran perangkat.

---

# 29. Accessibility

Ukuran teks minimal 14 px.

Target sentuh minimal 48 × 48 px.

Kontras warna mengikuti standar WCAG.

Seluruh tombol memiliki label.

---

# 30. Future Design

Versi berikutnya akan mendukung

- Dark Mode
- Dynamic Theme
- Tablet Layout
- Widget Home Screen
- Adaptive Icon
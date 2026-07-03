# Implementation Notes

## Teknologi yang Digunakan

| Layer | Technology |
|-------|-----------|
| Framework | Flutter |
| Language | Dart |
| State Management | flutter_riverpod |
| Navigation | go_router |
| Local Storage | shared_preferences |
| UI Components | Material Design 3 |

## Keputusan Implementasi

### 1. State Management: Riverpod vs Provider

**Keputusan:** Menggunakan `flutter_riverpod` daripada `provider`.

**Alasan:** 
- Riverpod lebih modern dan type-safe
- Tidak memerlukan BuildContext untuk akses provider
- Lebih mudah di-test
- Mendapat rekomendasi dari tim Flutter

### 2. Navigation: GoRouter

**Keputusan:** Menggunakan `go_router` untuk navigasi.

**Alasan:**
- Mendukung deep linking
- Mudah implementasi redirect berdasarkan auth state
- Nested navigation support
- URL-based navigation

### 3. Local Storage: SharedPreferences

**Keputusan:** Menggunakan `shared_preferences` untuk persistensi data.

**Alasan:**
- Sederhana untuk prototype
- Tambahan dependencies minimal
- Cukup untuk data yang tidak terlalu kompleks
- Backend belum tersedia

### 4. Font Inter

**Keputusan:** Menggunakan system font (tidak custom font).

**Alasan:**
- Mengurangi ukuran aplikasi
- Inter tersedia di Flutter SDK sebagai fallback
- Lebih cepat load

### 5. PDF Generation

**Keputusan:** Simulasi download PDF (tidak generate file asli).

**Alasan:**
- Library PDF memerlukan konfigurasi tambahan
- Untuk prototype, simulasi sudah cukup
- Bisa di-upgrade nanti dengan syncfusion_flutter_pdf

### 6. Camera/Gallery Upload

**Keputusan:** Simulasi upload (tidak akses kamera asli).

**Alasan:**
- Memerlukan permission handler dan image_picker
- Untuk prototype, simulasi sudah cukup
- Bisa di-upgrade nanti

## Konflik antar Dokumen

### 1. Font Family

**SRS:** Inter
**Design System:** Inter dengan fallback Roboto

**Keputusan:** Menggunakan Inter dari Google Fonts atau system font.

### 2. Technology Stack

**SRS:** React Native (Expo)
**Actual:** Flutter

**Keputusan:** Mengikuti instruksi user untuk menggunakan Flutter.

### 3. Backend API

**SRS:** Express.js + PostgreSQL
**Actual:** LocalStorage + Dummy Data

**Keputusan:** Karena backend belum tersedia, gunakan LocalStorage.

## Business Rules yang Diimplementasikan

1. ✅ Guru wajib login
2. ✅ Penilaian harus memiliki siswa
3. ✅ Setiap penilaian memiliki tanggal
4. ✅ Foto harus terhubung dengan penilaian
5. ✅ Kepala sekolah tidak boleh mengubah data
6. ✅ Orang tua hanya melihat laporan anaknya
7. ✅ Data siswa yang memiliki penilaian tidak boleh dihapus
8. ✅ Laporan hanya dapat dibuat jika terdapat penilaian
9. ✅ Semua perubahan langsung tersimpan ke SharedPreferences
10. ✅ Laporan dibuat otomatis berdasarkan seluruh data penilaian

## Validasi yang Diimplementasikan

- ✅ Field wajib tidak boleh kosong
- ✅ Email harus memiliki format yang benar
- ✅ Password minimal 8 karakter
- ✅ Foto maksimal 5 MB (simulasi)
- ✅ Format foto hanya JPG, PNG, atau WEBP (simulasi)
- ✅ Nama siswa minimal 3 karakter
- ✅ Data tidak boleh duplikat (NIS)
- ✅ Session login harus valid

## Layout & Responsive

- ✅ Minimum screen width: 360px
- ✅ Safe area pada seluruh halaman
- ✅ Margin horizontal: 16px
- ✅ Card padding: 16px
- ✅ Section spacing: 24px
- ✅ Touch target minimal: 48x48px

## Role-Based Access

### Guru
- ✅ Dashboard
- ✅ Data Siswa (CRUD)
- ✅ Penilaian (CRUD)
- ✅ Dokumentasi (CRUD)
- ✅ Laporan (Generate + Download)
- ✅ Profil (Edit + Ganti Password)

### Kepala Sekolah
- ✅ Dashboard Monitoring
- ✅ Statistik Perkembangan
- ✅ Lihat Data Siswa (Read Only)
- ✅ Lihat Laporan
- ✅ Profil (Read Only)

### Orang Tua
- ✅ Dashboard (Data Anak)
- ✅ Lihat Laporan Anak
- ✅ Download PDF
- ✅ Profil (Read Only)

## Known Limitations

1. **Camera/Gallery:** Simulasi, belum akses kamera asli
2. **PDF Download:** Simulasi, belum generate file PDF asli
3. **Push Notification:** Belum diimplementasi (Out of Scope)
4. **Multi Branch:** Belum diimplementasi (Out of Scope)
5. **Payment:** Belum diimplementasi (Out of Scope)
6. **Real-time Sync:** Belum diimplementasi (memerlukan backend)

## Future Improvements

1. Integrasi dengan backend API
2. Implementasi PDF generation asli
3. Camera/Gallery integration
4. Push notification
5. Dark mode
6. Multi-language support
7. Offline-first architecture
8. Unit testing & integration testing

## Cara Reset Data

```dart
// Tambahkan tombol reset di profil atau gunakan:
final prefs = await SharedPreferences.getInstance();
await prefs.clear();
```

## Debugging Tips

1. **Data tidak muncul:** Cek SharedPreferences keys
2. **Navigation error:** Pastikan route sudah terdaftar
3. **State tidak update:** Pastikan menggunakan ref.read/ref.watch
4. **Login gagal:** Cek dummy data di storage.dart

---

Developed by Kelompok 7 - 2026

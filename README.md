# 🏫 TK Islam Safa - Sistem Informasi Penilaian & Administrasi Siswa

<p align="center">
  <img src="assets/logo_safa.png" alt="Logo TK Islam Safa" width="120px" height="120px" />
</p>

<p align="center">
  <strong>Sistem Manajemen Penilaian Perkembangan Siswa dan Administrasi Terintegrasi</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-v3.0.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-v3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/Supabase-Database-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white" />
  <img src="https://img.shields.io/badge/Riverpod-State%20Management-02569B?style=for-the-badge" />
</p>

---

## 📌 Deskripsi Proyek

TK Islam Safa memiliki banyak peserta didik yang membutuhkan evaluasi perkembangan berkala. Sebelumnya, proses pencatatan penilaian perkembangan anak dan absensi masih terfragmentasi serta dilakukan secara manual. Hal ini memakan waktu dan berisiko terjadinya ketidakakuratan data.

**Sistem Informasi Penilaian & Administrasi TK Islam Safa** adalah aplikasi mobile berbasis **Flutter** dan **Supabase** yang dirancang khusus untuk mempermudah guru dalam mendokumentasikan hasil belajar siswa secara real-time. Selain itu, sistem ini menyediakan dashboard monitoring untuk Kepala Sekolah dan portal informasi perkembangan anak secara transparan untuk Orang Tua.

> [!NOTE]
> **Informasi Platform:** Aplikasi ini dikembangkan khusus untuk perangkat mobile (Android/iOS) dan **tidak menyediakan versi Web**. Akses pengguna sepenuhnya dilakukan melalui instalasi aplikasi seluler.

---

## 👥 Hak Akses & Fitur Utama (Role-Based Features)

Aplikasi ini mendukung tiga peran pengguna (*roles*) dengan hak akses yang berbeda:

### 1. 👩‍🏫 Guru (Teacher)
* **Manajemen Siswa (CRUD):** Mengelola data profil siswa, NIS, kelas, dan kontak orang tua.
* **Manajemen Penilaian:** Mengisi penilaian aspek perkembangan anak (Motorik, Kognitif, Bahasa, Sosial-Emosional) beserta catatan guru.
* **Dokumentasi Kegiatan:** Mengunggah foto kegiatan belajar mengajar atau aktivitas siswa ke storage database.
* **Laporan Perkembangan:** Menghasilkan (*generate*) rapor perkembangan berkala dan mengunduhnya dalam format PDF.

### 2. 🧕 Kepala Sekolah (Principal)
* **Monitoring Dashboard:** Melihat statistik umum perkembangan siswa di setiap kelas.
* **Review Data:** Melihat data siswa, rekam jejak penilaian, dan laporan perkembangan secara keseluruhan (Read-Only).
* **Profil Institusi:** Memantau kinerja pengajaran guru.

### 3. 👨‍👩‍👧 Orang Tua (Parent)
* **Portal Anak:** Melihat rangkuman aktivitas harian, absensi, dan dokumentasi foto anak mereka.
* **Rapor Digital:** Melihat nilai perkembangan anak dan catatan dari guru wali kelas.
* **Download Laporan:** Mengunduh berkas laporan hasil penilaian anak dalam format PDF secara langsung.

---

## 🛠️ Teknologi yang Digunakan

| Komponen | Teknologi / Library | Deskripsi |
|---|---|---|
| **Frontend Framework** | `Flutter` | SDK UI Multi-platform untuk Android & iOS |
| **State Management** | `flutter_riverpod` | Arsitektur state management yang deklaratif dan type-safe |
| **Routing & Navigation** | `go_router` | Penanganan navigasi deklaratif dan deep-linking |
| **Backend & Database** | `supabase_flutter` | PostgreSQL database, otentikasi pengguna, dan storage foto |
| **Penyimpanan Lokal** | `shared_preferences` | Caching sesi pengguna dan data offline sementara |
| **Konfigurasi Variabel** | `flutter_dotenv` | Manajemen kredensial API secara aman melalui file `.env` |
| **Utilitas Tambahan** | `uuid`, `intl`, `pdf`, `image_picker` | Format tanggal lokal, ID unik, pembuat PDF, dan picker galeri |

---

## 📂 Struktur Direktori Proyek

```text
lib/
├── config/          # Warna, tipografi, rute navigasi, dan konfigurasi API
├── models/          # Deklarasi model data (Siswa, Penilaian, User, dll.)
├── providers/       # Riverpod state providers (Auth, Siswa, Penilaian)
├── screens/         # Halaman UI (Auth, Dashboard, Siswa, Laporan, dll.)
├── services/        # Service eksternal (Supabase Service)
├── utils/           # Helper fungsi, validator, dan penyimpanan lokal
├── widgets/         # Kumpulan komponen UI reusable (Button, TextField, dll.)
└── main.dart        # Titik masuk utama aplikasi Flutter
```

---

## 🚀 Cara Menjalankan Aplikasi

### 1. Prasyarat Sistem
* Sudah menginstal [Flutter SDK](https://docs.flutter.dev/get-started/install) (versi `>=3.0.0`).
* Sudah menginstal editor kode seperti [VS Code](https://code.visualstudio.com/) atau [Android Studio](https://developer.android.com/studio).
* Perangkat fisik Android/iOS yang terhubung atau Emulator (AVD/Simulator) yang aktif.

### 2. Kloning Repositori
```bash
git clone https://github.com/AndreanDwij/TK_ISLAM_SAFA.git
cd TK_ISLAM_SAFA
```

### 3. Konfigurasi Variabel Lingkungan (.env)
Buat file bernama `.env` di direktori utama (root) proyek Anda dan masukkan konfigurasi Supabase Anda:
```env
SUPABASE_URL=https://gyejtjgwwehdbqjucodq.supabase.co
SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
```

### 4. Instalasi Dependensi
Jalankan perintah berikut di terminal root proyek untuk mengunduh seluruh pustaka yang diperlukan:
```bash
flutter pub get
```

### 5. Jalankan Aplikasi (Mode Debug)
Gunakan perintah berikut untuk mendownload dan menjalankan aplikasi di device/emulator:
```bash
flutter run
```

### 6. Build Aplikasi Rilis (Android APK)
Untuk mengompilasi aplikasi menjadi file APK versi rilis (`.apk` siap instal di HP):
```bash
flutter build apk --release
```
*File APK yang dihasilkan akan berada di direktori `build/app/outputs/flutter-apk/app-release.apk`.*

---

## 📦 Unduh APK Rilis (Google Drive)

Untuk mempermudah instalasi langsung di perangkat Android tanpa melakukan proses build manual, Anda dapat mengunduh berkas `.apk` versi siap pakai melalui tautan berikut:

👉 **[Unduh TK Islam Safa APK (Release v1.0.0)](https://drive.google.com/drive/folders/1V3evNn2OG0OQ8yakrSs_QP8yGgm5gypP)**

---

## 👥 Tim Pengembang (Kelompok 7)

Kami adalah mahasiswa Semester 4 program studi Sistem Informasi yang mengembangkan aplikasi ini untuk memenuhi tugas mata kuliah Desain dan Pemrograman Sistem Informasi (DPSI):

| Nama Anggota | NIM | Peran Utama |
|---|---|---|
| **Andrean Dwi Julyan** | 2400016026 | Project Leader & Backend Integrator |
| **Bahaudin Gutsantowi** | 2400016008 | UI Designer & Frontend Developer |
| **Muhammad Zidan Awwalu Naja** | 2400016010 | Database Designer & QA Engineer |
| **Aldi Mustarih** | 2400016055 | System Analyst & Documenter |
| **Abil Sabilillah** | 2400016077 | UI/UX Researcher & Technical Writer |

---

## 🔗 Repositori GitHub

Seluruh kode sumber dan riwayat pengembangan proyek ini dapat diakses secara publik melalui tautan repositori resmi kami berikut:

👉 **[GitHub - AndreanDwij/TK_ISLAM_SAFA](https://github.com/AndreanDwij/TK_ISLAM_SAFA)**

---

## 📄 Lisensi

Proyek ini dilindungi di bawah Hak Cipta © Kelompok 7 - 2026. Dikembangkan sebagai bagian akademis untuk menunjang administrasi pendidikan di TK Islam Safa.

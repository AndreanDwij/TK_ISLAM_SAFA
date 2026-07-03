# TK Islam Safa - Sistem Informasi Penilaian

Sistem Informasi Penilaian dan Administrasi Siswa TK Islam Safa.

## Flutter SDK Requirements

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0 < 4.0.0
- Android Studio / VS Code dengan Flutter extension
- Android SDK minimal versi 9 (API 28)
- iOS minimal versi 15

## Installation

```bash
# Clone repository
cd tk_safa_app

# Install dependencies
flutter pub get

# Run the application
flutter run
```

## Running the Application

```bash
# Jalankan di device/emulator
flutter run

# Jalankan di web
flutter run -d chrome

# Build release
flutter build apk
flutter build ios
```

## Login Credentials

### Guru
- Email: `guru@safa.com`
- Password: `password123`

### Kepala Sekolah
- Email: `kepala@safa.com`
- Password: `password123`

### Orang Tua
- Email: `orangtua@safa.com`
- Password: `password123`

## Features

### Guru
- Login/Logout
- Dashboard dengan ringkasan aktivitas
- Kelola Data Siswa (CRUD)
- Input Penilaian Perkembangan
- Upload Dokumentasi
- Generate Laporan Perkembangan
- Edit Profil & Ganti Password

### Kepala Sekolah
- Login/Logout
- Dashboard Monitoring
- Melihat Statistik Perkembangan Siswa
- Melihat Laporan

### Orang Tua
- Login/Logout
- Dashboard dengan data anak
- Melihat Laporan Perkembangan Anak
- Download PDF Laporan

## Testing the Application

1. Jalankan aplikasi dengan `flutter run`
2. Login dengan salah satu akun di atas
3. Navigasi menggunakan Bottom Navigation
4. Test setiap fitur sesuai role yang dipilih

### Test Scenarios

#### UC-001 Login
- Buka aplikasi → Splash Screen → Login
- Test validasi email kosong
- Test validasi password kosong
- Test login dengan email salah
- Test login dengan password salah
- Test login berhasil → Dashboard

#### UC-002 Kelola Data Siswa
- Buka menu Siswa
- Tambah siswa baru
- Edit data siswa
- Hapus siswa (tanpa penilaian)
- Test validasi NIS duplikat

#### UC-003 Input Penilaian
- Buka menu Penilaian
- Tambah penilaian baru
- Pilih siswa, aspek, nilai, catatan
- Test validasi field kosong

#### UC-004 Upload Dokumentasi
- Buka menu Dokumentasi
- Upload foto dari kamera/galeri
- Tambah deskripsi
- Hapus dokumentasi

#### UC-005 Generate Laporan
- Buka menu Laporan
- Pilih siswa dan semester
- Generate laporan
- Download PDF

#### UC-006 Monitoring (Kepala Sekolah)
- Login sebagai Kepala Sekolah
- Lihat statistik perkembangan
- Lihat grafik per aspek

#### UC-007 Melihat Laporan Anak (Orang Tua)
- Login sebagai Orang Tua
- Lihat laporan perkembangan anak
- Download PDF laporan

## Resetting SharedPreferences/Local Data

Untuk mereset semua data ke kondisi awal:

### Android
1. Buka Settings → Apps → TK Islam Safa
2. Pilih "Clear Data" atau "Hapus Data"

### iOS
1. Hapus aplikasi dari device
2. Install ulang aplikasi

### Cara Manual (via Code)
Tambahkan tombol reset di profil atau gunakan:

```dart
// Untuk reset semua data
final prefs = await SharedPreferences.getInstance();
await prefs.clear();
```

### Reset via Aplikasi
1. Login sebagai Guru
2. Buka Profil
3. Tekan "Tentang Aplikasi"
4. (Fitur reset bisa ditambahkan di sini)

## Project Structure

```
tk_safa_app/
├── lib/
│   ├── main.dart                    # Entry point
│   ├── app/
│   │   ├── app.dart                 # App widget
│   │   └── routes.dart              # Route configuration
│   ├── config/
│   │   ├── colors.dart              # Color palette
│   │   ├── typography.dart          # Typography styles
│   │   ├── theme.dart               # App theme
│   │   ├── spacing.dart             # Spacing system
│   │   ├── radius.dart              # Border radius
│   │   └── shadows.dart             # Box shadows
│   ├── models/
│   │   ├── user.dart                # User model
│   │   ├── student.dart             # Student model
│   │   ├── assessment.dart          # Assessment model
│   │   └── documentation.dart       # Documentation model
│   ├── providers/
│   │   ├── auth_provider.dart       # Authentication state
│   │   ├── student_provider.dart    # Student state
│   │   ├── assessment_provider.dart # Assessment state
│   │   └── documentation_provider.dart
│   ├── screens/
│   │   ├── splash/splash_screen.dart
│   │   ├── auth/login_screen.dart
│   │   ├── dashboard/
│   │   │   ├── dashboard_screen.dart
│   │   │   ├── guru_dashboard.dart
│   │   │   ├── kepala_dashboard.dart
│   │   │   └── orang_tua_dashboard.dart
│   │   ├── siswa/
│   │   │   ├── siswa_list_screen.dart
│   │   │   ├── siswa_detail_screen.dart
│   │   │   └── siswa_form_screen.dart
│   │   ├── penilaian/
│   │   │   ├── penilaian_list_screen.dart
│   │   │   └── penilaian_form_screen.dart
│   │   ├── dokumentasi/dokumentasi_screen.dart
│   │   ├── laporan/laporan_screen.dart
│   │   ├── monitoring/monitoring_screen.dart
│   │   └── profil/
│   │       ├── profil_screen.dart
│   │       ├── edit_profil_screen.dart
│   │       └── ganti_password_screen.dart
│   ├── utils/
│   │   ├── storage.dart             # SharedPreferences helper
│   │   └── validators.dart          # Form validators
│   └── widgets/
│       ├── app_bar.dart
│       ├── bottom_nav.dart
│       ├── button.dart
│       ├── card.dart
│       ├── chart_bar.dart
│       ├── dialog.dart
│       ├── dropdown.dart
│       ├── empty_state.dart
│       ├── error_state.dart
│       ├── filter_chip.dart
│       ├── list_item.dart
│       ├── loading.dart
│       ├── search_bar.dart
│       ├── snackbar.dart
│       ├── stat_card.dart
│       └── text_field.dart
├── pubspec.yaml
├── analysis_options.yaml
├── README.md
└── IMPLEMENTATION_NOTES.md
```

## Dummy Data

Data awal yang tersimpan di SharedPreferences:

### Users
| Nama | Email | Password | Role |
|------|-------|----------|------|
| Ibu Sarah | guru@safa.com | password123 | Guru |
| Pak Budi | kepala@safa.com | password123 | Kepala Sekolah |
| Pak Ahmad | orangtua@safa.com | password123 | Orang Tua |

### Siswa
| NIS | Nama | Kelas |
|-----|------|-------|
| 2024001 | Ahmad Rizki | A |
| 2024002 | Siti Nurhaliza | A |
| 2024003 | Muhammad Fadil | B |

### Penilaian
| Siswa | Aspek | Nilai | Semester |
|-------|-------|-------|----------|
| Ahmad Rizki | Motorik Kasar | 85 | Ganjil 2024 |
| Ahmad Rizki | Bahasa | 90 | Ganjil 2024 |

## License

Developed by Kelompok 7 - 2026

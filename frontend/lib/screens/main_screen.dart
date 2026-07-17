import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../widgets/bottom_nav.dart';
import 'dashboard/dashboard_screen.dart';
import 'siswa/siswa_list_screen.dart';
import 'penilaian/penilaian_list_screen.dart';
import 'dokumentasi/dokumentasi_screen.dart';
import 'laporan/laporan_screen.dart';
import 'profil/profil_screen.dart';
import 'monitoring/monitoring_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final role = user?.role;

    return Scaffold(
      body: _buildBody(role),
      bottomNavigationBar: _buildBottomNav(role),
    );
  }

  Widget _buildBody(UserRole? role) {
    switch (role) {
      case UserRole.guru:
        final validIndex = _currentIndex.clamp(0, _guruPages.length - 1);
        return _guruPages[validIndex];
      case UserRole.kepalaSekolah:
        final validIndex = _currentIndex.clamp(0, _kepalaPages.length - 1);
        return _kepalaPages[validIndex];
      case UserRole.orangTua:
        final validIndex = _currentIndex.clamp(0, _orangTuaPages.length - 1);
        return _orangTuaPages[validIndex];
      default:
        final validIndex = _currentIndex.clamp(0, _guruPages.length - 1);
        return _guruPages[validIndex];
    }
  }

  Widget? _buildBottomNav(UserRole? role) {
    switch (role) {
      case UserRole.guru:
        return BottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        );
      case UserRole.kepalaSekolah:
        return BottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Monitoring',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outlined),
              activeIcon: Icon(Icons.people),
              label: 'Siswa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assessment_outlined),
              activeIcon: Icon(Icons.assessment),
              label: 'Penilaian',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.photo_library_outlined),
              activeIcon: Icon(Icons.photo_library),
              label: 'Dokumentasi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined),
              activeIcon: Icon(Icons.description),
              label: 'Laporan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        );
      case UserRole.orangTua:
        return BottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined),
              activeIcon: Icon(Icons.description),
              label: 'Laporan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        );
      default:
        return BottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        );
    }
  }

  List<Widget> get _guruPages => [
        const DashboardScreen(),
        const SiswaListScreen(),
        const PenilaianListScreen(),
        const DokumentasiScreen(),
        const LaporanScreen(),
        const ProfilScreen(),
      ];

  List<Widget> get _kepalaPages => [
        const MonitoringScreen(),
        const SiswaListScreen(),
        const PenilaianListScreen(),
        const DokumentasiScreen(),
        const LaporanScreen(),
        const ProfilScreen(),
      ];

  List<Widget> get _orangTuaPages => [
        const DashboardScreen(),
        const LaporanScreen(),
        const ProfilScreen(),
      ];
}

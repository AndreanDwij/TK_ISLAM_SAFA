import 'package:flutter/material.dart';
import '../config/colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem>? items;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.items,
  });

  @override
  Widget build(BuildContext context) {
    final navItems = items ?? _defaultItems;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex.clamp(0, navItems.length - 1),
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.grey,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          elevation: 0,
          items: navItems,
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> get _defaultItems => const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Beranda',
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
      ];
}

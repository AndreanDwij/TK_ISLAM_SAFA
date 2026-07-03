import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/colors.dart';
import '../../config/typography.dart';
import '../../config/spacing.dart';
import '../../providers/auth_provider.dart';
import '../../models/user.dart';
import '../../widgets/dialog.dart';
import '../../widgets/button.dart';

class ProfilScreen extends ConsumerWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    String roleText = '';
    switch (user?.role) {
      case UserRole.guru:
        roleText = 'Guru';
        break;
      case UserRole.kepalaSekolah:
        roleText = 'Kepala Sekolah';
        break;
      case UserRole.orangTua:
        roleText = 'Orang Tua';
        break;
      default:
        roleText = 'Pengguna';
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Gradient Header with Avatar
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF16A34A), Color(0xFF059669)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      'Profil',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        user?.name.substring(0, 1).toUpperCase() ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.name ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      roleText,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Menu Items
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Spacing.lg),
              child: Column(
                children: [
                  _buildMenuItem(
                    context: context,
                    icon: Icons.edit_outlined,
                    title: 'Edit Profil',
                    subtitle: 'Ubah informasi profil Anda',
                    gradient: AppColors.primaryGradient,
                    onTap: () => context.push('/profil/edit'),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.lock_outline,
                    title: 'Ganti Password',
                    subtitle: 'Ubah kata sandi akun',
                    gradient: AppColors.blueGradient,
                    onTap: () => context.push('/profil/password'),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.info_outline,
                    title: 'Tentang Aplikasi',
                    subtitle: 'TK Islam Safa v1.0.0',
                    gradient: AppColors.tealGradient,
                    onTap: () => _showAbout(context),
                  ),
                  const SizedBox(height: 20),
                  // Logout
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => _showLogoutDialog(context, ref),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [AppColors.error, Color(0xFFB91C1C)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.logout, color: Colors.white, size: 22),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Logout',
                                      style: TextStyle(
                                        color: AppColors.error,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Keluar dari akun',
                                      style: AppTypography.caption.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: AppColors.error),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: gradient.colors.first.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    AppDialog.show(
      context: context,
      title: 'Logout',
      message: 'Apakah Anda yakin ingin logout?',
      confirmText: 'Logout',
      isDanger: true,
      onConfirm: () async {
        await ref.read(authProvider.notifier).logout();
        if (context.mounted) {
          context.go('/login');
        }
      },
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        icon: Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.school, color: Colors.white, size: 32),
        ),
        title: const Text('TK Islam Safa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sistem Informasi Penilaian dan Administrasi Siswa',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.lg),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.lightGreenBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Versi 1.0.0',
                  style: TextStyle(
                    color: AppColors.deepGreen,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              'Dikembangkan untuk mempermudah proses penilaian perkembangan siswa TK Islam Safa.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Center(
            child: AppButton(
              text: 'Tutup',
              onPressed: () => Navigator.pop(context),
              isSecondary: true,
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.all(Spacing.lg),
      ),
    );
  }
}

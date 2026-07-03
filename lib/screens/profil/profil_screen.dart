import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/colors.dart';
import '../../config/typography.dart';
import '../../config/spacing.dart';
import '../../providers/auth_provider.dart';
import '../../models/user.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/card.dart';
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
      appBar: const AppAppBar(
        title: 'Profil',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          children: [
            // Profile Header
            const SizedBox(height: Spacing.lg),
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Text(
                user?.name.substring(0, 1).toUpperCase() ?? '',
                style: AppTypography.h2.copyWith(color: AppColors.primary),
              ),
            ),
            const SizedBox(height: Spacing.lg),
            Text(user?.name ?? '', style: AppTypography.h4),
            const SizedBox(height: Spacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.md,
                vertical: Spacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                roleText,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              user?.email ?? '',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: Spacing.xxl),

            // Menu Items
            AppCard(
              onTap: () => context.push('/profil/edit'),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.edit, color: AppColors.primary),
                  ),
                  const SizedBox(width: Spacing.lg),
                  const Expanded(child: Text('Edit Profil')),
                  const Icon(Icons.chevron_right, color: AppColors.grey),
                ],
              ),
            ),
            AppCard(
              onTap: () => context.push('/profil/password'),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.lock, color: AppColors.info),
                  ),
                  const SizedBox(width: Spacing.lg),
                  const Expanded(child: Text('Ganti Password')),
                  const Icon(Icons.chevron_right, color: AppColors.grey),
                ],
              ),
            ),
            AppCard(
              onTap: () => _showAbout(context),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.info, color: AppColors.secondary),
                  ),
                  const SizedBox(width: Spacing.lg),
                  const Expanded(child: Text('Tentang Aplikasi')),
                  const Icon(Icons.chevron_right, color: AppColors.grey),
                ],
              ),
            ),
            const SizedBox(height: Spacing.lg),

            // Logout Button
            AppCard(
              onTap: () => _showLogoutDialog(context, ref),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.logout, color: AppColors.error),
                  ),
                  const SizedBox(width: Spacing.lg),
                  Expanded(
                    child: Text(
                      'Logout',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
          borderRadius: BorderRadius.circular(16),
        ),
        icon: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.school, color: AppColors.primary, size: 32),
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
              child: Text('Versi 1.0.0', style: AppTypography.caption),
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

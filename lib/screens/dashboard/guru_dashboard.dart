import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/colors.dart';
import '../../config/typography.dart';
import '../../config/spacing.dart';
import '../../providers/auth_provider.dart';
import '../../providers/student_provider.dart';
import '../../providers/assessment_provider.dart';
import '../../providers/documentation_provider.dart';
import '../../widgets/card.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/list_item.dart';

class GuruDashboard extends ConsumerWidget {
  const GuruDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final studentState = ref.watch(studentProvider);
    final assessmentState = ref.watch(assessmentProvider);
    final docState = ref.watch(documentationProvider);

    final todayAssessments = assessmentState.assessments.where((a) {
      final now = DateTime.now();
      return a.date.year == now.year &&
          a.date.month == now.month &&
          a.date.day == now.day;
    }).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting
          Text(
            'Selamat datang,',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            authState.user?.name ?? '',
            style: AppTypography.h3,
          ),
          const SizedBox(height: Spacing.xxl),

          // Stats Grid
          Row(
            children: [
              Expanded(
                child: AppStatCard(
                  icon: Icons.people,
                  label: 'Total Siswa',
                  value: '${studentState.students.length}',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: AppStatCard(
                  icon: Icons.assessment,
                  label: 'Penilaian Hari Ini',
                  value: '$todayAssessments',
                  color: AppColors.info,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              Expanded(
                child: AppStatCard(
                  icon: Icons.photo_library,
                  label: 'Dokumentasi',
                  value: '${docState.documentations.length}',
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: AppStatCard(
                  icon: Icons.description,
                  label: 'Total Penilaian',
                  value: '${assessmentState.assessments.length}',
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xxl),

          // Menu Section
          Text('Menu Utama', style: AppTypography.h5),
          const SizedBox(height: Spacing.md),
          _MenuCard(
            icon: Icons.people,
            title: 'Data Siswa',
            subtitle: 'Kelola data siswa',
            onTap: () => context.push('/siswa'),
          ),
          _MenuCard(
            icon: Icons.assessment,
            title: 'Penilaian',
            subtitle: 'Input penilaian siswa',
            onTap: () => context.push('/penilaian'),
          ),
          _MenuCard(
            icon: Icons.photo_library,
            title: 'Dokumentasi',
            subtitle: 'Upload dokumentasi',
            onTap: () => context.push('/dokumentasi'),
          ),
          _MenuCard(
            icon: Icons.description,
            title: 'Laporan',
            subtitle: 'Generate laporan',
            onTap: () => context.push('/laporan'),
          ),
          const SizedBox(height: Spacing.xxl),

          // Recent Activity
          Text('Riwayat Aktivitas', style: AppTypography.h5),
          const SizedBox(height: Spacing.md),
          if (assessmentState.assessments.isEmpty)
            AppCard(
              child: Text(
                'Belum ada aktivitas',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            )
          else
            ...assessmentState.assessments.take(3).map(
                  (a) => AppCard(
                    child: AppListItem(
                      title: a.studentName,
                      subtitle: a.aspect,
                      trailing: '${a.score}',
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        child: const Icon(Icons.assessment, color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: Spacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodyLarge),
                Text(subtitle, style: AppTypography.caption),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.grey),
        ],
      ),
    );
  }
}

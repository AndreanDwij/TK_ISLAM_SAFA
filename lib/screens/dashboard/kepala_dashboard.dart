import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/colors.dart';
import '../../config/typography.dart';
import '../../config/spacing.dart';
import '../../providers/auth_provider.dart';
import '../../providers/student_provider.dart';
import '../../providers/assessment_provider.dart';
import '../../widgets/card.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/chart_bar.dart';

class KepalaDashboard extends ConsumerWidget {
  const KepalaDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final studentState = ref.watch(studentProvider);
    final assessmentState = ref.watch(assessmentProvider);

    final averageScore = assessmentState.assessments.isEmpty
        ? 0.0
        : assessmentState.assessments.map((a) => a.score).reduce((a, b) => a + b) /
            assessmentState.assessments.length;

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

          // Stats
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
                  label: 'Total Penilaian',
                  value: '${assessmentState.assessments.length}',
                  color: AppColors.info,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          AppStatCard(
            icon: Icons.trending_up,
            label: 'Rata-rata Nilai',
            value: averageScore.toStringAsFixed(1),
            color: AppColors.secondary,
          ),
          const SizedBox(height: Spacing.xxl),

          // Chart
          Text('Statistik Perkembangan', style: AppTypography.h5),
          const SizedBox(height: Spacing.md),
          Builder(
            builder: (context) {
              double aspectAverage(String keyword) {
                final filtered = assessmentState.assessments
                    .where((a) => a.aspect.toLowerCase().contains(keyword.toLowerCase()))
                    .toList();
                if (filtered.isEmpty) return 0.0;
                return filtered.map((a) => a.score).reduce((a, b) => a + b) /
                    filtered.length;
              }

              final motorikAvg = aspectAverage('motorik');
              final bahasaAvg = aspectAverage('bahasa');
              final kognitifAvg = aspectAverage('kognitif');
              final sosialAvg = aspectAverage('sosial');

              return AppCard(
                child: Column(
                  children: [
                    AppChartBar(label: 'Motorik', value: motorikAvg, color: AppColors.primary),
                    AppChartBar(label: 'Bahasa', value: bahasaAvg, color: AppColors.info),
                    AppChartBar(label: 'Kognitif', value: kognitifAvg, color: AppColors.secondary),
                    AppChartBar(label: 'Sosial', value: sosialAvg, color: AppColors.warning),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: Spacing.xxl),

          // Recent Students
          Text('Siswa Terbaru', style: AppTypography.h5),
          const SizedBox(height: Spacing.md),
          ...studentState.students.take(5).map((student) {
            final studentAssessments = assessmentState.assessments
                .where((a) => a.studentId == student.id)
                .toList();

            return AppCard(
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      student.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: Spacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(student.name, style: AppTypography.bodyLarge),
                        Text(
                          'Kelas ${student.className}',
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.sm,
                      vertical: Spacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${studentAssessments.length} penilaian',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

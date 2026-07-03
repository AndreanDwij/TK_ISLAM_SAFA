import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/colors.dart';
import '../../config/typography.dart';
import '../../config/spacing.dart';
import '../../providers/student_provider.dart';
import '../../providers/assessment_provider.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/card.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/chart_bar.dart';
import '../../widgets/empty_state.dart';

class MonitoringScreen extends ConsumerWidget {
  const MonitoringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentState = ref.watch(studentProvider);
    final assessmentState = ref.watch(assessmentProvider);

    final averageScore = assessmentState.assessments.isEmpty
        ? 0.0
        : assessmentState.assessments.map((a) => a.score).reduce((a, b) => a + b) /
            assessmentState.assessments.length;

    final Map<String, int> aspectCounts = {};
    for (final a in assessmentState.assessments) {
      aspectCounts[a.aspect] = (aspectCounts[a.aspect] ?? 0) + 1;
    }

    final Map<String, double> aspectAverages = {};
    for (final a in assessmentState.assessments) {
      final current = aspectAverages[a.aspect] ?? 0;
      aspectAverages[a.aspect] = current + a.score;
    }
    aspectAverages.forEach((key, value) {
      aspectAverages[key] = value / (aspectCounts[key] ?? 1);
    });

    return Scaffold(
      appBar: const AppAppBar(
        title: 'Monitoring Perkembangan',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // UC-006 Main Flow: Step 4 - System displays statistics
            Text('Statistik Umum', style: AppTypography.h5),
            const SizedBox(height: Spacing.md),
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
              label: 'Rata-rata Nilai Keseluruhan',
              value: averageScore.toStringAsFixed(1),
              color: AppColors.secondary,
            ),
            const SizedBox(height: Spacing.xxl),

            // UC-006 Acceptance Criteria: Charts displayed
            Text('Statistik Per Aspek', style: AppTypography.h5),
            const SizedBox(height: Spacing.md),
            AppCard(
              child: aspectAverages.isEmpty
                  // UC-006 Alternative Flow: No data
                  ? const AppEmptyState(
                      message: 'Belum ada data penilaian',
                      icon: Icons.assessment_outlined,
                    )
                  : Column(
                      children: aspectAverages.entries.map((entry) {
                        final color = _getColorForAspect(entry.key);
                        return AppChartBar(
                          label: entry.key,
                          value: entry.value,
                          color: color,
                        );
                      }).toList(),
                    ),
            ),
            const SizedBox(height: Spacing.xxl),

            // UC-006 Main Flow: Step 5-6 - Select student and show details
            Text('Daftar Siswa', style: AppTypography.h5),
            const SizedBox(height: Spacing.md),
            ...studentState.students.map((student) {
              final studentAssessments = assessmentState.assessments
                  .where((a) => a.studentId == student.id)
                  .toList();
              final studentAvg = studentAssessments.isEmpty
                  ? 0.0
                  : studentAssessments.map((a) => a.score).reduce((a, b) => a + b) /
                      studentAssessments.length;

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
                            'Kelas ${student.className} | ${studentAssessments.length} penilaian',
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          studentAvg.toStringAsFixed(1),
                          style: AppTypography.h5.copyWith(color: AppColors.primary),
                        ),
                        Text('rata-rata', style: AppTypography.caption),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _getColorForAspect(String aspect) {
    switch (aspect) {
      case 'Motorik Kasar':
        return AppColors.primary;
      case 'Motorik Halus':
        return AppColors.secondary;
      case 'Bahasa':
        return AppColors.info;
      case 'Kognitif':
        return AppColors.warning;
      case 'Sosial Emosional':
        return AppColors.error;
      case 'Seni':
        return Colors.purple;
      case 'Agama':
        return Colors.teal;
      default:
        return AppColors.grey;
    }
  }
}

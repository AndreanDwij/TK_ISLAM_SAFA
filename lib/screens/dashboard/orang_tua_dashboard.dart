import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/colors.dart';
import '../../config/typography.dart';
import '../../config/spacing.dart';
import '../../providers/auth_provider.dart';
import '../../models/student.dart';
import '../../providers/student_provider.dart';
import '../../providers/assessment_provider.dart';
import '../../widgets/card.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/empty_state.dart';

class OrangTuaDashboard extends ConsumerWidget {
  const OrangTuaDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final studentState = ref.watch(studentProvider);
    final assessmentState = ref.watch(assessmentProvider);

    // UC-007: Parent can only see their child
    final childId = authState.user?.childId;
    if (childId == null || studentState.students.isEmpty) {
      return const SizedBox.shrink();
    }
    final child = studentState.students.firstWhere(
      (s) => s.id == childId,
      orElse: () => Student(
        id: '', nis: '', name: '', gender: 'Laki-laki',
        birthDate: DateTime.now(), className: '', parentName: '',
        parentPhone: '', createdAt: DateTime.now(),
      ),
    );

    // UC-007 Acceptance Criteria: Only child's report accessible
    final childAssessments = assessmentState.assessments
        .where((a) => a.studentId == childId)
        .toList();

    final averageScore = childAssessments.isEmpty
        ? 0.0
        : childAssessments.map((a) => a.score).reduce((a, b) => a + b) /
            childAssessments.length;

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

          // UC-007: Child Profile Card
          AppCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    child.name.substring(0, 1).toUpperCase(),
                    style: AppTypography.h3.copyWith(color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: Spacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(child.name, style: AppTypography.h5),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        'Kelas ${child.className}',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.lg),

          // Stats
          Row(
            children: [
              Expanded(
                child: AppStatCard(
                  icon: Icons.assessment,
                  label: 'Total Penilaian',
                  value: '${childAssessments.length}',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: AppStatCard(
                  icon: Icons.trending_up,
                  label: 'Rata-rata Nilai',
                  value: averageScore.toStringAsFixed(1),
                  color: AppColors.info,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xxl),

          // UC-007 Main Flow: Step 5-6 - Report displayed
          Text('Riwayat Penilaian', style: AppTypography.h5),
          const SizedBox(height: Spacing.md),
          if (childAssessments.isEmpty)
            // UC-007 Alternative Flow: No report
            AppCard(
              child: const AppEmptyState(
                message: 'Belum ada penilaian',
                description: 'Laporan perkembangan akan muncul setelah guru menginput penilaian',
                icon: Icons.assessment_outlined,
              ),
            )
          else
            ...childAssessments.take(5).map((a) => AppCard(
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.assessment,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: Spacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a.aspect, style: AppTypography.bodyMedium),
                            Text(
                              a.note,
                              style: AppTypography.caption,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${a.score}',
                        style: AppTypography.h5.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }
}

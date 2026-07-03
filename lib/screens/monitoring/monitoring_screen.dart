import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/colors.dart';
import '../../config/typography.dart';
import '../../config/spacing.dart';
import '../../providers/student_provider.dart';
import '../../providers/assessment_provider.dart';
import '../../widgets/chart_bar.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/stat_card.dart';

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
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Gradient Header
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Monitoring Perkembangan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Quick stats row
                  Row(
                    children: [
                      Expanded(
                        child: _QuickStat(
                          icon: Icons.people,
                          label: 'Siswa',
                          value: '${studentState.students.length}',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _QuickStat(
                          icon: Icons.assessment,
                          label: 'Penilaian',
                          value: '${assessmentState.assessments.length}',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _QuickStat(
                          icon: Icons.trending_up,
                          label: 'Rata-rata',
                          value: averageScore.toStringAsFixed(1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stat Cards
                  Row(
                    children: [
                      Expanded(
                        child: AppStatCard(
                          icon: Icons.people,
                          label: 'Total Siswa',
                          value: '${studentState.students.length}',
                          color: AppColors.schoolBlue,
                        ),
                      ),
                      const SizedBox(width: Spacing.md),
                      Expanded(
                        child: AppStatCard(
                          icon: Icons.assessment,
                          label: 'Total Penilaian',
                          value: '${assessmentState.assessments.length}',
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.md),
                  AppStatCard(
                    icon: Icons.trending_up,
                    label: 'Rata-rata Nilai Keseluruhan',
                    value: averageScore.toStringAsFixed(1),
                    color: AppColors.schoolPink,
                  ),
                  const SizedBox(height: Spacing.xxl),

                  // Aspect Statistics
                  _buildSectionTitle('Statistik Per Aspek', AppColors.purple),
                  const SizedBox(height: Spacing.md),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.purple.withValues(alpha: 0.12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.purple.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: aspectAverages.isEmpty
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

                  // Student List
                  _buildSectionTitle('Daftar Siswa', AppColors.teal),
                  const SizedBox(height: Spacing.md),
                  ...studentState.students.asMap().entries.map((entry) {
                    final index = entry.key;
                    final student = entry.value;
                    final studentAssessments = assessmentState.assessments
                        .where((a) => a.studentId == student.id)
                        .toList();
                    final studentAvg = studentAssessments.isEmpty
                        ? 0.0
                        : studentAssessments.map((a) => a.score).reduce((a, b) => a + b) /
                            studentAssessments.length;

                    final colors = [
                      AppColors.primary, AppColors.schoolBlue, AppColors.schoolPink,
                      AppColors.purple, AppColors.teal, AppColors.orange,
                    ];
                    final color = colors[index % colors.length];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: color.withValues(alpha: 0.12),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [color, color.withValues(alpha: 0.7)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Text(
                                student.name.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  student.name,
                                  style: AppTypography.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: color.withValues(alpha: 0.08),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'Kelas ${student.className}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: color,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${studentAssessments.length} penilaian',
                                      style: AppTypography.caption,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [color, color.withValues(alpha: 0.8)],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  studentAvg.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
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
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.5)]),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTypography.h5.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
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

class _QuickStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _QuickStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.9), size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

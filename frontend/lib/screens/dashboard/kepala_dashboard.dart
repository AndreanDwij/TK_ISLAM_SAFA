import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/colors.dart';
import '../../config/typography.dart';
import '../../config/spacing.dart';
import '../../providers/auth_provider.dart';
import '../../providers/student_provider.dart';
import '../../providers/assessment_provider.dart';

class KepalaDashboard extends ConsumerWidget {
  const KepalaDashboard({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final studentState = ref.watch(studentProvider);
    final assessmentState = ref.watch(assessmentProvider);

    final averageScore = assessmentState.assessments.isEmpty
        ? 0.0
        : assessmentState.assessments.map((a) => a.score).reduce((a, b) => a + b) /
            assessmentState.assessments.length;

    double aspectAvg(String keyword) {
      final filtered = assessmentState.assessments
          .where((a) => a.aspect.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
      if (filtered.isEmpty) return 0.0;
      return filtered.map((a) => a.score).reduce((a, b) => a + b) /
          filtered.length;
    }

    final motorikAvg = aspectAvg('motorik');
    final bahasaAvg = aspectAvg('bahasa');
    final kognitifAvg = aspectAvg('kognitif');
    final sosialAvg = aspectAvg('sosial');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting Banner
          _GreetingBanner(
            greeting: _greeting(),
            userName: authState.user?.name ?? '',
          ),
          const SizedBox(height: Spacing.xxl),

          // Ringkasan - Circular progress indicators
          _RingkasanSection(
            totalStudents: studentState.students.length,
            totalAssessments: assessmentState.assessments.length,
            averageScore: averageScore,
          ),
          const SizedBox(height: Spacing.xxl),

          // Monitoring Chart Section
          _MonitoringChart(
            motorikAvg: motorikAvg,
            bahasaAvg: bahasaAvg,
            kognitifAvg: kognitifAvg,
            sosialAvg: sosialAvg,
          ),
          const SizedBox(height: Spacing.xxl),

          // Recent Students - Cards with gradient left border
          Text('Siswa Terbaru', style: AppTypography.h5),
          const SizedBox(height: Spacing.md),
          ...studentState.students.take(5).map((student) {
            final studentAssessments = assessmentState.assessments
                .where((a) => a.studentId == student.id)
                .toList();

            final colors = [
              const Color(0xFF16A34A),
              const Color(0xFF2196F3),
              const Color(0xFFE91E8C),
              const Color(0xFFF5C518),
              const Color(0xFF8BC34A),
            ];
            final color = colors[studentState.students.indexOf(student) % colors.length];

            return _StudentCard(
              name: student.name,
              className: student.className,
              assessmentCount: studentAssessments.length,
              color: color,
            );
          }),
        ],
      ),
    );
  }
}

class _GreetingBanner extends StatelessWidget {
  final String greeting;
  final String userName;

  const _GreetingBanner({required this.greeting, required this.userName});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(Spacing.xxl, Spacing.xxl, Spacing.xxl, 36),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2196F3), Color(0xFF1565C0)],
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Floating decorations
            Positioned(
              top: -18,
              right: -18,
              child: _DecorCircle(size: 100, color: Colors.white.withValues(alpha: 0.07)),
            ),
            Positioned(
              top: 25,
              right: 50,
              child: _DecorCircle(size: 35, color: Colors.white.withValues(alpha: 0.1)),
            ),
            Positioned(
              bottom: -28,
              left: -12,
              child: _DecorCircle(size: 80, color: Colors.white.withValues(alpha: 0.05)),
            ),
            Positioned(
              bottom: 10,
              left: 50,
              child: _DecorCircle(size: 14, color: Colors.white.withValues(alpha: 0.12)),
            ),
            Positioned(
              top: 15,
              left: -8,
              child: _DecorCircle(size: 24, color: Colors.white.withValues(alpha: 0.08)),
            ),
            // Small diamond shape
            Positioned(
              top: 45,
              right: 15,
              child: Transform.rotate(
                angle: pi / 4,
                child: Container(
                  width: 12,
                  height: 12,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.shield_rounded,
                      color: Colors.white.withValues(alpha: 0.6),
                      size: 18,
                    ),
                    const SizedBox(width: Spacing.sm),
                    Text(
                      '$greeting,',
                      style: AppTypography.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  userName,
                  style: AppTypography.h3.copyWith(color: Colors.white),
                ),
                const SizedBox(height: Spacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.md,
                    vertical: Spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Monitoring perkembangan sekolah',
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DecorCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _DecorCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _RingkasanSection extends StatelessWidget {
  final int totalStudents;
  final int totalAssessments;
  final double averageScore;

  const _RingkasanSection({
    required this.totalStudents,
    required this.totalAssessments,
    required this.averageScore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.pie_chart_rounded, size: 20, color: AppColors.primary),
            const SizedBox(width: Spacing.sm),
            Text('Ringkasan', style: AppTypography.h5),
          ],
        ),
        const SizedBox(height: Spacing.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(Spacing.xl),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _CircularProgressItem(
                label: 'Siswa',
                value: totalStudents / 50,
                display: '$totalStudents',
                color: const Color(0xFF16A34A),
              ),
              _CircularProgressItem(
                label: 'Penilaian',
                value: totalAssessments / 100,
                display: '$totalAssessments',
                color: const Color(0xFF2196F3),
              ),
              _CircularProgressItem(
                label: 'Rata-rata',
                value: averageScore / 100,
                display: averageScore.toStringAsFixed(0),
                color: const Color(0xFFE91E8C),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CircularProgressItem extends StatelessWidget {
  final String label;
  final double value;
  final String display;
  final Color color;

  const _CircularProgressItem({
    required this.label,
    required this.value,
    required this.display,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 72,
          height: 72,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: value.clamp(0.0, 1.0),
                strokeWidth: 8,
                backgroundColor: color.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                strokeCap: StrokeCap.round,
              ),
              Center(
                child: Text(
                  display,
                  style: AppTypography.h5.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Text(
          label,
          style: AppTypography.caption,
        ),
      ],
    );
  }
}

class _MonitoringChart extends StatelessWidget {
  final double motorikAvg;
  final double bahasaAvg;
  final double kognitifAvg;
  final double sosialAvg;

  const _MonitoringChart({
    required this.motorikAvg,
    required this.bahasaAvg,
    required this.kognitifAvg,
    required this.sosialAvg,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.lg,
            vertical: Spacing.md,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF2196F3), Color(0xFF42A5F5)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(Icons.bar_chart_rounded, color: Colors.white, size: 20),
              const SizedBox(width: Spacing.sm),
              Text(
                'Statistik Perkembangan',
                style: AppTypography.h5.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(Spacing.xl),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _RoundedBar(
                label: 'Motorik',
                value: motorikAvg,
                color: const Color(0xFF16A34A),
                icon: Icons.directions_run_rounded,
              ),
              const SizedBox(height: Spacing.md),
              _RoundedBar(
                label: 'Bahasa',
                value: bahasaAvg,
                color: const Color(0xFF2196F3),
                icon: Icons.chat_rounded,
              ),
              const SizedBox(height: Spacing.md),
              _RoundedBar(
                label: 'Kognitif',
                value: kognitifAvg,
                color: const Color(0xFFE91E8C),
                icon: Icons.psychology_rounded,
              ),
              const SizedBox(height: Spacing.md),
              _RoundedBar(
                label: 'Sosial',
                value: sosialAvg,
                color: const Color(0xFFF5C518),
                icon: Icons.groups_rounded,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RoundedBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final IconData icon;

  const _RoundedBar({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: Spacing.md),
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(width: Spacing.sm),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (value / 100).clamp(0.0, 1.0),
              backgroundColor: color.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 16,
            ),
          ),
        ),
        const SizedBox(width: Spacing.sm),
        SizedBox(
          width: 36,
          child: Text(
            value.toStringAsFixed(1),
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

class _StudentCard extends StatelessWidget {
  final String name;
  final String className;
  final int assessmentCount;
  final Color color;

  const _StudentCard({
    required this.name,
    required this.className,
    required this.assessmentCount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.md),
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border(
              left: BorderSide(color: color, width: 4),
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.lg,
            vertical: Spacing.md,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.7)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    name.substring(0, 1).toUpperCase(),
                    style: AppTypography.h5.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Spacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Kelas $className',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md,
                  vertical: Spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$assessmentCount penilaian',
                  style: AppTypography.bodySmall.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

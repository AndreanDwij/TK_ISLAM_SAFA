import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/colors.dart';
import '../../config/typography.dart';
import '../../config/spacing.dart';
import '../../providers/auth_provider.dart';
import '../../models/student.dart';
import '../../providers/student_provider.dart';
import '../../providers/assessment_provider.dart';
import '../../widgets/empty_state.dart';

class OrangTuaDashboard extends ConsumerWidget {
  const OrangTuaDashboard({super.key});

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

    final childId = authState.user?.childId;

    if (studentState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (childId == null) {
      return const AppEmptyState(
        message: 'Belum Terhubung dengan Siswa',
        description: 'Hubungi admin/guru untuk menghubungkan akun Orang Tua Anda dengan anak Anda di sistem.',
        icon: Icons.person_off_outlined,
      );
    }

    if (studentState.students.isEmpty) {
      return const AppEmptyState(
        message: 'Tidak Ada Data Siswa',
        description: 'Data siswa belum tersedia atau gagal dimuat di dalam sistem.',
        icon: Icons.people_outline,
      );
    }

    final child = studentState.students.firstWhere(
      (s) => s.id == childId,
      orElse: () => Student(
        id: '', nis: '', name: '', gender: 'Laki-laki',
        birthDate: DateTime.now(), className: '', parentName: '',
        parentPhone: '', createdAt: DateTime.now(),
      ),
    );

    if (child.id.isEmpty) {
      return const AppEmptyState(
        message: 'Siswa Tidak Ditemukan',
        description: 'Akun Anda terhubung dengan ID siswa yang tidak terdaftar di sistem.',
        icon: Icons.warning_amber_rounded,
      );
    }

    final childAssessments = assessmentState.assessments
        .where((a) => a.studentId == childId)
        .toList();

    final averageScore = childAssessments.isEmpty
        ? 0.0
        : childAssessments.map((a) => a.score).reduce((a, b) => a + b) /
            childAssessments.length;

    double aspectAvg(String keyword) {
      final filtered = childAssessments
          .where((a) => a.aspect.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
      if (filtered.isEmpty) return 0.0;
      return filtered.map((a) => a.score).reduce((a, b) => a + b) /
          filtered.length;
    }

    final motorik = aspectAvg('motorik');
    final bahasa = aspectAvg('bahasa');
    final kognitif = aspectAvg('kognitif');
    final sosial = aspectAvg('sosial');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting - Warm pink/rose theme with soft shapes
          _GreetingBanner(
            greeting: _greeting(),
            userName: authState.user?.name ?? '',
          ),
          const SizedBox(height: Spacing.xxl),

          // Child Profile - Card with photo-style frame
          _ChildProfileCard(child: child),
          const SizedBox(height: Spacing.lg),

          // Quick Stats
          Row(
            children: [
              Expanded(
                child: _WarmStatCard(
                  icon: Icons.assessment_rounded,
                  label: 'Total Penilaian',
                  value: '${childAssessments.length}',
                  color: const Color(0xFF16A34A),
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: _WarmStatCard(
                  icon: Icons.trending_up_rounded,
                  label: 'Rata-rata Nilai',
                  value: averageScore.toStringAsFixed(1),
                  color: const Color(0xFF2196F3),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xxl),

          // Aspect Progress - Circular progress indicators
          if (childAssessments.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.pie_chart_rounded, size: 20, color: const Color(0xFFE91E8C)),
                const SizedBox(width: Spacing.sm),
                Text('Perkembangan per Aspek', style: AppTypography.h5),
              ],
            ),
            const SizedBox(height: Spacing.md),
            _CircularAspectGrid(
              aspects: [
                _AspectData('Motorik', motorik, const Color(0xFF16A34A), Icons.directions_run_rounded),
                _AspectData('Bahasa', bahasa, const Color(0xFF2196F3), Icons.chat_rounded),
                _AspectData('Kognitif', kognitif, const Color(0xFFE91E8C), Icons.psychology_rounded),
                _AspectData('Sosial', sosial, const Color(0xFFF5C518), Icons.groups_rounded),
              ],
            ),
            const SizedBox(height: Spacing.xxl),
          ],

          // Assessment History - Timeline with colored dots
          Text('Riwayat Penilaian', style: AppTypography.h5),
          const SizedBox(height: Spacing.md),
          if (childAssessments.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Spacing.xxxl),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.greyLight),
              ),
              child: const AppEmptyState(
                message: 'Belum ada penilaian',
                description: 'Laporan perkembangan akan muncul setelah guru menginput penilaian',
                icon: Icons.assessment_outlined,
              ),
            )
          else
            _AssessmentTimeline(assessments: childAssessments.take(5).toList()),
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
            colors: [Color(0xFFE91E8C), Color(0xFFF06292)],
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Floating soft shapes
            Positioned(
              top: -15,
              right: -20,
              child: _SoftCircle(size: 95, color: Colors.white.withValues(alpha: 0.08)),
            ),
            Positioned(
              top: 35,
              right: 45,
              child: _SoftCircle(size: 40, color: Colors.white.withValues(alpha: 0.1)),
            ),
            Positioned(
              top: -5,
              right: 85,
              child: _SoftCircle(size: 18, color: Colors.white.withValues(alpha: 0.15)),
            ),
            Positioned(
              bottom: -30,
              left: 25,
              child: _SoftCircle(size: 75, color: Colors.white.withValues(alpha: 0.06)),
            ),
            Positioned(
              bottom: 8,
              left: 55,
              child: _SoftCircle(size: 12, color: Colors.white.withValues(alpha: 0.12)),
            ),
            // Heart-like accent
            Positioned(
              top: 50,
              right: 10,
              child: Icon(
                Icons.favorite_rounded,
                color: Colors.white.withValues(alpha: 0.12),
                size: 20,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.favorite_rounded,
                      color: Colors.white.withValues(alpha: 0.7),
                      size: 16,
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
                    'Lihat perkembangan buah hati Anda',
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

class _SoftCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _SoftCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _ChildProfileCard extends StatelessWidget {
  final Student child;

  const _ChildProfileCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE91E8C).withValues(alpha: 0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE91E8C).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Photo-style frame
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE91E8C), Color(0xFFF472B6)],
              ),
            ),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  child.name.substring(0, 1).toUpperCase(),
                  style: AppTypography.h3.copyWith(
                    color: const Color(0xFFE91E8C),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: Spacing.xl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(child.name, style: AppTypography.h5),
                const SizedBox(height: Spacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.md,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCE7F3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Kelas ${child.className}',
                    style: AppTypography.bodySmall.copyWith(
                      color: const Color(0xFFE91E8C),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Decorative dots
          Column(
            children: [
              _SmallDot(color: const Color(0xFFE91E8C).withValues(alpha: 0.3)),
              const SizedBox(height: 4),
              _SmallDot(color: const Color(0xFFF472B6).withValues(alpha: 0.5)),
              const SizedBox(height: 4),
              _SmallDot(color: const Color(0xFFE91E8C).withValues(alpha: 0.2)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallDot extends StatelessWidget {
  final Color color;

  const _SmallDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _WarmStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _WarmStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.lg,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            value,
            style: AppTypography.h4.copyWith(color: color),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.caption,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _AspectData {
  final String label;
  final double value;
  final Color color;
  final IconData icon;

  const _AspectData(this.label, this.value, this.color, this.icon);
}

class _CircularAspectGrid extends StatelessWidget {
  final List<_AspectData> aspects;

  const _CircularAspectGrid({required this.aspects});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: Spacing.xl,
          crossAxisSpacing: Spacing.xl,
          childAspectRatio: 0.9,
        ),
        itemCount: aspects.length,
        itemBuilder: (context, index) {
          final aspect = aspects[index];
          return _CircularAspectItem(data: aspect);
        },
      ),
    );
  }
}

class _CircularAspectItem extends StatelessWidget {
  final _AspectData data;

  const _CircularAspectItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 68,
          height: 68,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: (data.value / 100).clamp(0.0, 1.0),
                strokeWidth: 8,
                backgroundColor: data.color.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation<Color>(data.color),
                strokeCap: StrokeCap.round,
              ),
              Center(
                child: Text(
                  data.value.toStringAsFixed(0),
                  style: AppTypography.h5.copyWith(
                    color: data.color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.sm,
            vertical: 3,
          ),
          decoration: BoxDecoration(
            color: data.color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(data.icon, size: 12, color: data.color),
              const SizedBox(width: 4),
              Text(
                data.label,
                style: AppTypography.caption.copyWith(
                  color: data.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AssessmentTimeline extends StatelessWidget {
  final List assessments;

  const _AssessmentTimeline({required this.assessments});

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFF16A34A),
      const Color(0xFF2196F3),
      const Color(0xFFE91E8C),
      const Color(0xFFF5C518),
      const Color(0xFF8BC34A),
    ];

    return Column(
      children: List.generate(assessments.length, (index) {
        final a = assessments[index];
        final color = colors[index % colors.length];
        final isLast = index == assessments.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline dot + line
              SizedBox(
                width: 32,
                child: Column(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: AppColors.greyLight,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.sm),
              // Content card
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: Spacing.md),
                  padding: const EdgeInsets.all(Spacing.md),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: color.withValues(alpha: 0.15),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, color.withValues(alpha: 0.7)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.assessment_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: Spacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              a.aspect,
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              a.note,
                              style: AppTypography.caption,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.sm,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${a.score}',
                          style: AppTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: color,
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
      }),
    );
  }
}

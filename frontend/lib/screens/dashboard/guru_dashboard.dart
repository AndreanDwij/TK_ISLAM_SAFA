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

class GuruDashboard extends ConsumerWidget {
  const GuruDashboard({super.key});

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
          // Greeting Banner - Organic shape with floating decorations
          _GreetingBanner(
            greeting: _greeting(),
            userName: authState.user?.name ?? '',
          ),
          const SizedBox(height: Spacing.xxl),

          // Stats - Asymmetric layout: 2 big + 2 small
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: _BigStatCard(
                  icon: Icons.people_rounded,
                  label: 'Total Siswa',
                  value: '${studentState.students.length}',
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF16A34A), Color(0xFF059669)],
                  ),
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                flex: 2,
                child: _SmallStatCard(
                  icon: Icons.assessment_rounded,
                  label: 'Hari Ini',
                  value: '$todayAssessments',
                  color: const Color(0xFF2196F3),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _SmallStatCard(
                  icon: Icons.photo_library_rounded,
                  label: 'Dokumentasi',
                  value: '${docState.documentations.length}',
                  color: const Color(0xFFE91E8C),
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                flex: 3,
                child: _BigStatCard(
                  icon: Icons.description_rounded,
                  label: 'Total Penilaian',
                  value: '${assessmentState.assessments.length}',
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFF5C518), Color(0xFFF97316)],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xxl),

          // Menu Section - Colorful gradient grid
          Text('Menu Utama', style: AppTypography.h5),
          const SizedBox(height: Spacing.md),
          _MenuGrid(
            items: [
              _MenuItem(
                icon: Icons.people_rounded,
                title: 'Data Siswa',
                subtitle: 'Kelola data siswa',
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF16A34A), Color(0xFF0D9488)],
                ),
                onTap: () => context.push('/siswa'),
              ),
              _MenuItem(
                icon: Icons.assessment_rounded,
                title: 'Penilaian',
                subtitle: 'Input penilaian siswa',
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                ),
                onTap: () => context.push('/penilaian'),
              ),
              _MenuItem(
                icon: Icons.photo_library_rounded,
                title: 'Dokumentasi',
                subtitle: 'Upload dokumentasi',
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE91E8C), Color(0xFFC2185B)],
                ),
                onTap: () => context.push('/dokumentasi'),
              ),
              _MenuItem(
                icon: Icons.description_rounded,
                title: 'Laporan',
                subtitle: 'Generate laporan',
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF5C518), Color(0xFFFFA000)],
                ),
                onTap: () => context.push('/laporan'),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xxl),

          // Recent Activity - Timeline style
          Text('Riwayat Aktivitas', style: AppTypography.h5),
          const SizedBox(height: Spacing.md),
          if (assessmentState.assessments.isEmpty)
            _EmptyTimelineCard()
          else
            _TimelineActivity(
              assessments: assessmentState.assessments.take(4).toList(),
            ),
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
            colors: [Color(0xFF16A34A), Color(0xFF0D9488)],
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Floating decorative circles
            Positioned(
              top: -20,
              right: -15,
              child: _FloatingDot(size: 90, color: Colors.white.withValues(alpha: 0.08)),
            ),
            Positioned(
              top: 30,
              right: 40,
              child: _FloatingDot(size: 45, color: Colors.white.withValues(alpha: 0.1)),
            ),
            Positioned(
              top: -8,
              right: 80,
              child: _FloatingDot(size: 20, color: Colors.white.withValues(alpha: 0.15)),
            ),
            Positioned(
              bottom: -25,
              left: 30,
              child: _FloatingDot(size: 70, color: Colors.white.withValues(alpha: 0.06)),
            ),
            Positioned(
              bottom: 5,
              left: 60,
              child: _FloatingDot(size: 16, color: Colors.white.withValues(alpha: 0.12)),
            ),
            Positioned(
              top: 20,
              left: -10,
              child: _FloatingDot(size: 30, color: Colors.white.withValues(alpha: 0.07)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Decorative star/sparkle icon
                    Icon(
                      Icons.wb_sunny_rounded,
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
                    'Siap mengajar hari ini?',
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

class _FloatingDot extends StatelessWidget {
  final double size;
  final Color color;

  const _FloatingDot({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class _BigStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Gradient gradient;

  const _BigStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -10,
            right: -10,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(height: Spacing.lg),
              Text(
                value,
                style: AppTypography.h2.copyWith(color: Colors.white),
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SmallStatCard({
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

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Gradient gradient;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });
}

class _MenuGrid extends StatelessWidget {
  final List<_MenuItem> items;

  const _MenuGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: Spacing.md,
        crossAxisSpacing: Spacing.md,
        childAspectRatio: 1.0,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _MenuCard(item: item);
      },
    );
  }
}

class _MenuCard extends StatelessWidget {
  final _MenuItem item;

  const _MenuCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.all(Spacing.lg),
        decoration: BoxDecoration(
          gradient: item.gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              bottom: -12,
              right: -12,
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Positioned(
              top: -6,
              right: -6,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(item.icon, color: Colors.white, size: 26),
                ),
                const SizedBox(height: Spacing.md),
                Text(
                  item.title,
                  style: AppTypography.labelLarge.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: AppTypography.caption.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyTimelineCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.xxxl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.greyLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.timeline_rounded,
              size: 32,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: Spacing.md),
          Text(
            'Belum ada aktivitas',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineActivity extends StatelessWidget {
  final List assessments;

  const _TimelineActivity({required this.assessments});

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFF16A34A),
      const Color(0xFF2196F3),
      const Color(0xFFE91E8C),
      const Color(0xFFF5C518),
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
              // Timeline dot and line
              SizedBox(
                width: 32,
                child: Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
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
                    border: Border.all(color: color.withValues(alpha: 0.15), width: 1.5),
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
                              a.studentName,
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              a.aspect,
                              style: AppTypography.caption,
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

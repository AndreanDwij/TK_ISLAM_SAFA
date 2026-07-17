import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../config/typography.dart';
import '../config/spacing.dart';

class AppStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  const AppStatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.onTap,
  });

  LinearGradient _getGradient() {
    if (color == AppColors.primary) return AppColors.primaryGradient;
    if (color == AppColors.info) return AppColors.blueGradient;
    if (color == AppColors.secondary) return AppColors.tealGradient;
    if (color == AppColors.schoolPink) return AppColors.pinkGradient;
    if (color == AppColors.warning) return AppColors.yellowGradient;
    return LinearGradient(
      colors: [color, color.withValues(alpha: 0.8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final gradient = _getGradient();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Spacing.lg),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              value,
              style: AppTypography.h3.copyWith(color: Colors.white),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

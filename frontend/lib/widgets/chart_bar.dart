import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../config/typography.dart';
import '../config/spacing.dart';

class AppChartBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final double maxValue;

  const AppChartBar({
    super.key,
    required this.label,
    required this.value,
    this.color = AppColors.primary,
    this.maxValue = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.md),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTypography.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value / maxValue,
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 12,
              ),
            ),
          ),
          const SizedBox(width: Spacing.sm),
          SizedBox(
            width: 32,
            child: Text(
              '$value',
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

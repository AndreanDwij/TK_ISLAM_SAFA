import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../config/typography.dart';
import '../config/spacing.dart';
import 'button.dart';

class AppErrorState extends StatelessWidget {
  final String message;
  final String? description;
  final IconData? icon;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const AppErrorState({
    super.key,
    required this.message,
    this.description,
    this.icon,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.error_outline,
                size: 40,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: Spacing.lg),
            Text(
              message,
              style: AppTypography.h5.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              const SizedBox(height: Spacing.sm),
              Text(
                description!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: Spacing.xxl),
              AppButton(
                text: buttonText!,
                onPressed: onButtonPressed,
                icon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

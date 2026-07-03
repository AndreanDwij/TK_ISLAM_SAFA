import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../config/typography.dart';
import '../config/radius.dart';

enum AppButtonSize { large, medium, small }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isSecondary;
  final bool isDanger;
  final bool isDisabled;
  final IconData? icon;
  final AppButtonSize size;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isSecondary = false,
    this.isDanger = false,
    this.isDisabled = false,
    this.icon,
    this.size = AppButtonSize.large,
  });

  double get _height {
    switch (size) {
      case AppButtonSize.large:
        return 48;
      case AppButtonSize.medium:
        return 40;
      case AppButtonSize.small:
        return 32;
    }
  }

  TextStyle get _textStyle {
    switch (size) {
      case AppButtonSize.large:
        return AppTypography.buttonLarge;
      case AppButtonSize.medium:
        return AppTypography.buttonMedium;
      case AppButtonSize.small:
        return AppTypography.buttonSmall;
    }
  }

  double get _iconSize {
    switch (size) {
      case AppButtonSize.large:
        return 20;
      case AppButtonSize.medium:
        return 18;
      case AppButtonSize.small:
        return 16;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = !isLoading && !isDisabled && onPressed != null;

    if (isSecondary) {
      return SizedBox(
        height: _height,
        child: OutlinedButton(
          onPressed: enabled ? onPressed : null,
          style: OutlinedButton.styleFrom(
            foregroundColor: enabled ? AppColors.primary : AppColors.grey,
            side: BorderSide(
              color: enabled ? AppColors.primary : AppColors.grey,
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.button,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: _buildChild(enabled),
        ),
      );
    }

    if (isDanger) {
      return SizedBox(
        height: _height,
        child: ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: enabled ? AppColors.error : AppColors.grey,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.button,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            elevation: enabled ? 2 : 0,
          ),
          child: _buildChild(enabled),
        ),
      );
    }

    return SizedBox(
      height: _height,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? AppColors.primary : AppColors.grey,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.button,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          elevation: enabled ? 2 : 0,
        ),
        child: _buildChild(enabled),
      ),
    );
  }

  Widget _buildChild(bool enabled) {
    if (isLoading) {
      return SizedBox(
        width: _iconSize,
        height: _iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: isSecondary ? AppColors.primary : AppColors.white,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _iconSize),
          const SizedBox(width: 8),
          Text(text, style: _textStyle),
        ],
      );
    }

    return Text(text, style: _textStyle);
  }
}

import 'package:flutter/material.dart';
import '../config/typography.dart';
import '../config/colors.dart';
import '../config/radius.dart';
import 'button.dart';

class AppDialog {
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Ya',
    String cancelText = 'Batal',
    required VoidCallback onConfirm,
    bool isDanger = false,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.dialog,
        ),
        title: Text(title, style: AppTypography.h5),
        content: Text(message, style: AppTypography.bodyMedium),
        actions: [
          AppButton(
            text: cancelText,
            onPressed: () => Navigator.pop(context),
            isSecondary: true,
            size: AppButtonSize.small,
          ),
          const SizedBox(width: 12),
          AppButton(
            text: confirmText,
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            isDanger: isDanger,
            size: AppButtonSize.small,
          ),
        ],
        actionsAlignment: MainAxisAlignment.end,
        actionsPadding: const EdgeInsets.all(16),
      ),
    );
  }

  static void showSuccess({
    required BuildContext context,
    required String message,
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.dialog,
        ),
        icon: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle,
            color: AppColors.success,
            size: 40,
          ),
        ),
        title: const Text('Berhasil'),
        content: Text(
          message,
          style: AppTypography.bodyMedium,
          textAlign: TextAlign.center,
        ),
        actions: [
          AppButton(
            text: 'OK',
            onPressed: () {
              Navigator.pop(context);
              onPressed?.call();
            },
            size: AppButtonSize.medium,
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.all(16),
      ),
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.dialog,
        ),
        icon: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.error,
            color: AppColors.error,
            size: 40,
          ),
        ),
        title: const Text('Gagal'),
        content: Text(
          message,
          style: AppTypography.bodyMedium,
          textAlign: TextAlign.center,
        ),
        actions: [
          AppButton(
            text: 'OK',
            onPressed: () {
              Navigator.pop(context);
              onPressed?.call();
            },
            size: AppButtonSize.medium,
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.all(16),
      ),
    );
  }

  static void showWarning({
    required BuildContext context,
    required String message,
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.dialog,
        ),
        icon: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.warning,
            color: AppColors.warning,
            size: 40,
          ),
        ),
        title: const Text('Peringatan'),
        content: Text(
          message,
          style: AppTypography.bodyMedium,
          textAlign: TextAlign.center,
        ),
        actions: [
          AppButton(
            text: 'OK',
            onPressed: () {
              Navigator.pop(context);
              onPressed?.call();
            },
            size: AppButtonSize.medium,
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.all(16),
      ),
    );
  }
}

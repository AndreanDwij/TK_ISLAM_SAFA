import 'package:flutter/material.dart';
import '../config/typography.dart';
import '../config/colors.dart';
import '../config/radius.dart';
import '../config/spacing.dart';

class AppBottomSheet {
  static void show({
    required BuildContext context,
    required String title,
    required Widget child,
    bool showCloseButton = true,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: AppRadius.chip,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Spacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: AppTypography.h5),
                  if (showCloseButton)
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(Spacing.lg),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showOptions({
    required BuildContext context,
    required String title,
    required List<AppBottomSheetOption> options,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: AppRadius.chip,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Spacing.lg),
              child: Text(title, style: AppTypography.h5),
            ),
            const Divider(height: 1),
            ...options.map((option) => ListTile(
                  leading: Icon(option.icon, color: option.color ?? AppColors.primary),
                  title: Text(
                    option.title,
                    style: AppTypography.bodyLarge.copyWith(
                      color: option.color,
                    ),
                  ),
                  subtitle: option.subtitle != null
                      ? Text(option.subtitle!, style: AppTypography.caption)
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    option.onTap();
                  },
                )),
            const SizedBox(height: Spacing.lg),
          ],
        ),
      ),
    );
  }
}

class AppBottomSheetOption {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? color;
  final VoidCallback onTap;

  const AppBottomSheetOption({
    required this.icon,
    required this.title,
    this.subtitle,
    this.color,
    required this.onTap,
  });
}

import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../config/typography.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;

  const AppAppBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.actions,
    this.onBackPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null,
      actions: actions,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      elevation: 2,
      centerTitle: true,
      titleTextStyle: AppTypography.h5.copyWith(color: AppColors.white),
    );
  }
}

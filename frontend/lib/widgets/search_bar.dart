import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../config/typography.dart';
import '../config/radius.dart';

class AppSearchBar extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final Widget? prefixIcon;
  final bool autofocus;

  const AppSearchBar({
    super.key,
    this.hintText,
    this.controller,
    this.onChanged,
    this.onClear,
    this.prefixIcon,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.radiusMedium,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        autofocus: autofocus,
        style: AppTypography.input,
        decoration: InputDecoration(
          hintText: hintText ?? 'Cari...',
          hintStyle: AppTypography.inputHint,
          prefixIcon: prefixIcon ?? const Icon(Icons.search, color: AppColors.grey),
          suffixIcon: controller != null && controller!.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.grey),
                  onPressed: () {
                    controller?.clear();
                    onClear?.call();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../config/radius.dart';
import '../config/shadows.dart';
import '../config/spacing.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? width;
  final double? height;
  final bool showShadow;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.color,
    this.width,
    this.height,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: 8),
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: AppRadius.card,
        boxShadow: showShadow ? AppShadows.small : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.card,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.card,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(Spacing.cardPadding),
            child: child,
          ),
        ),
      ),
    );
  }
}

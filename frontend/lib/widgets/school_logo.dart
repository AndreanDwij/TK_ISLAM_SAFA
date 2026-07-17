import 'package:flutter/material.dart';
import '../config/colors.dart';

class SchoolLogo extends StatelessWidget {
  final double? size;

  const SchoolLogo({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    final s = size ?? 250;

    return Image.asset(
      'assets/logo_safa.png',
      width: s,
      height: s * 0.7,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (context, error, stackTrace) {
        return _buildFallbackLogo(s);
      },
    );
  }

  Widget _buildFallbackLogo(double s) {
    return Container(
      width: s,
      height: s * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.18),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school, size: s * 0.2, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(
            'TK ISLAM SAFA',
            style: TextStyle(
              fontSize: s * 0.07,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

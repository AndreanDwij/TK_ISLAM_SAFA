import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF16A34A);

  // Secondary
  static const Color secondary = Color(0xFF22C55E);

  // Background
  static const Color background = Color(0xFFF8FAFC);

  // Surface
  static const Color surface = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);

  // Border
  static const Color border = Color(0xFFE5E7EB);

  // Status
  static const Color success = Color(0xFF15803D);
  static const Color warning = Color(0xFFFACC15);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF3B82F6);

  // Neutral
  static const Color grey = Color(0xFF9CA3AF);
  static const Color greyLight = Color(0xFFF3F4F6);
  static const Color greyDark = Color(0xFF374151);

  // White
  static const Color white = Color(0xFFFFFFFF);

  // Black
  static const Color black = Color(0xFF000000);

  // School Accent Colors
  static const Color schoolYellow = Color(0xFFF5C518);
  static const Color schoolPink = Color(0xFFE91E8C);
  static const Color schoolBlue = Color(0xFF2196F3);
  static const Color schoolLightGreen = Color(0xFF8BC34A);
  static const Color purple = Color(0xFF9333EA);
  static const Color teal = Color(0xFF14B8A6);
  static const Color orange = Color(0xFFF97316);
  static const Color deepGreen = Color(0xFF059669);

  // Utility Background Colors
  static const Color lightBlueBg = Color(0xFFE0F2FE);
  static const Color lightPinkBg = Color(0xFFFCE7F3);
  static const Color lightGreenBg = Color(0xFFF0FDF4);
  static const Color lightYellowBg = Color(0xFFFEF9C3);
  static const Color lightPurpleBg = Color(0xFFF3E8FF);
  static const Color lightTealBg = Color(0xFFCCFBF1);

  // Gradient Combinations
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF16A34A), Color(0xFF22C55E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF42A5F5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pinkGradient = LinearGradient(
    colors: [Color(0xFFE91E8C), Color(0xFFF06292)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient yellowGradient = LinearGradient(
    colors: [Color(0xFFF5C518), Color(0xFFFFD54F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF9333EA), Color(0xFFA855F7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient tealGradient = LinearGradient(
    colors: [Color(0xFF14B8A6), Color(0xFF2DD4BF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFFB923C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF16A34A), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFF5C518)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient coolGradient = LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF9333EA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

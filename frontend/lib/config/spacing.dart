import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  // Spacing Scale
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double xxxxl = 40;
  static const double xxxxxl = 48;
  static const double xxxxxxl = 64;

  // Layout
  static const double marginHorizontal = 16;
  static const double marginVertical = 16;
  static const double cardPadding = 16;
  static const double sectionSpacing = 24;

  // Helpers
  static SizedBox get heightXs => const SizedBox(height: 4);
  static SizedBox get heightSm => const SizedBox(height: 8);
  static SizedBox get heightMd => const SizedBox(height: 12);
  static SizedBox get heightLg => const SizedBox(height: 16);
  static SizedBox get heightXl => const SizedBox(height: 20);
  static SizedBox get heightXxl => const SizedBox(height: 24);
  static SizedBox get heightXxxl => const SizedBox(height: 32);

  static SizedBox get widthXs => const SizedBox(width: 4);
  static SizedBox get widthSm => const SizedBox(width: 8);
  static SizedBox get widthMd => const SizedBox(width: 12);
  static SizedBox get widthLg => const SizedBox(width: 16);
  static SizedBox get widthXl => const SizedBox(width: 20);
  static SizedBox get widthXxl => const SizedBox(width: 24);
}

typedef Spacing = AppSpacing;

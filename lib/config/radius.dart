import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  // Border Radius Scale
  static const double small = 8;
  static const double medium = 12;
  static const double large = 16;
  static const double extraLarge = 24;
  static const double circle = 999;

  // BorderRadius Objects
  static BorderRadius get radiusSmall => BorderRadius.circular(small);
  static BorderRadius get radiusMedium => BorderRadius.circular(medium);
  static BorderRadius get radiusLarge => BorderRadius.circular(large);
  static BorderRadius get radiusExtraLarge => BorderRadius.circular(extraLarge);
  static BorderRadius get radiusCircle => BorderRadius.circular(circle);

  // Specific Use Cases
  static BorderRadius get card => radiusLarge;
  static BorderRadius get button => radiusMedium;
  static BorderRadius get input => const BorderRadius.all(Radius.circular(10));
  static BorderRadius get dialog => radiusLarge;
  static BorderRadius get bottomSheet => const BorderRadius.vertical(
        top: Radius.circular(extraLarge),
      );
  static BorderRadius get chip => radiusCircle;
  static BorderRadius get avatar => radiusCircle;
}

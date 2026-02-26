import 'package:flutter/material.dart';

class DesignConstants {
  DesignConstants._();

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 20.0;
  static const double radiusXLarge = 30.0;

  // Spacing
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 12.0;
  static const double spacingLarge = 16.0;
  static const double spacingXLarge = 24.0;

  // Icon Sizes
  static const double iconSizeSmall = 14.0;
  static const double iconSizeMedium = 16.0;
  static const double iconSizeMed = 24.0;
  static const double iconSizeLarge = 28.0;

  // Component Sizes
  static const double summaryIconContainerSize = 28.0;
  static const double progressBarHeight = 20.0;
  static const double savingsBannerHeight = 22.0;
  static const double indicatorCircleSize = 6.0;

  // Progress Bar
  static const double progressBarBorderWidth = 0.5;
  static const double progressBarBackgroundBorderWidth = 1.0;
  static const double progressBarMinWidth = 20.0;

  // Shadow
  static const Offset progressBarShadowOffset = Offset(0, 4);
  static const double progressBarShadowBlur = 8.0;
  static const double progressBarShadowOpacity = 0.12;
  static const int strokeAlpha = 10;
}

class GradientColors {
  GradientColors._();

  static const Color incomeStart = Color(0xFF0496AD);
  static const Color incomeEnd = Color(0xFF097C8E);

  static const Color expenseStart = Color(0xFFDC143C);
  static const Color expenseEnd = Color(0xFFA01A35);

  static List<Color> get incomeGradient => [incomeStart, incomeEnd];

  static List<Color> get expenseGradient => [expenseStart, expenseEnd];
}

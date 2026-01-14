import 'package:flutter/material.dart';

class ChartTheme {
  // Primary Color
  static const Color primary = Color(0xFFDC143C);

  // Gradient Colors
  static const Color gradientStart = Color(0xFFDC143C);
  static const Color gradientEnd = Color(0xFFDC143C);

  // Chart Colors
  static const Color lineColor = primary;
  static final Color gridLineColor = Colors.grey.withOpacity(0.2);
  static const Color tooltipBackground = Color(0xFFF8F8F8);
  static const Color tooltipBorder = Color(0xFFF1F1F1);
  static final Color textSecondary = Colors.grey[600]!;

  // Opacity Values
  static const double gradientStartOpacity = 0.32;
  static const double gradientEndOpacity = 0.0;

  // Sizes
  static const double lineWidth = 2.0;
  static const double dotRadius = 0.0;
  static const double touchedDotRadius = 4.0;
  static const double dotStrokeWidth = 0.0;
  static const double touchedDotStrokeWidth = 2.0;
  static const double borderRadius = 12.0;

  // Dashed Line
  static const double dashWidth = 4.0;
  static const double dashSpace = 4.0;

  // Tooltip
  static const double tooltipRadius = 8.0;
  static const double tooltipPaddingHorizontal = 12.0;
  static const double tooltipPaddingVertical = 8.0;
  static const double tooltipBorderWidth = 0.5;
  static const Color tooltipTextColor = Color(0xFF1F1F1F);
  static const double tooltipGap = 10.0;

  // Spacing
  static const double containerPadding = 16.0;
  static const double titleSpacing = 20.0;
  static const double chartHeight = 200.0;

  // Text Styles
  static const TextStyle titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle axisLabelStyle = TextStyle(
    fontSize: 10,
  );

  static const TextStyle tooltipTextStyle = TextStyle(
    fontFamily: 'Rubik',
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1.4, // 14px line height / 10px font size
    letterSpacing: 0,
    color: tooltipTextColor,
  );
}
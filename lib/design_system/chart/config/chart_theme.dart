import 'package:flutter/material.dart';
import '../../theme/money_colors.dart';
import '../../theme/money_typography.dart';
import 'chart_constants.dart';

/// Chart theme configuration that integrates with the app's design system.
///
/// This class provides theme-aware styling for charts by using
/// [MoneyColors] and [MoneyTypography] from the app's theme.
class ChartTheme {
  ChartTheme._();

  // Color Accessors
  static Color getPrimaryColor(BuildContext context) {
    return Theme.of(context).extension<MoneyColors>()?.primary ?? Colors.blue;
  }

  static Color getGridLineColor(BuildContext context) {
    return Theme.of(context).extension<MoneyColors>()?.stroke ??
        Colors.grey.withValues(alpha: 0.2);
  }

  static Color getTooltipBackground(BuildContext context) {
    return Theme.of(context).extension<MoneyColors>()?.surface ?? Colors.white;
  }

  static Color getTooltipBorder(BuildContext context) {
    return Theme.of(context).extension<MoneyColors>()?.stroke ??
        Colors.grey.withValues(alpha: 0.2);
  }

  static Color getTextSecondary(BuildContext context) {
    return Theme.of(context).extension<MoneyColors>()?.hint ?? Colors.grey;
  }

  static Color getSurfaceColor(BuildContext context) {
    return Theme.of(context).extension<MoneyColors>()?.surfaceLow ??
        Colors.white;
  }

  static Color getShadowColor(BuildContext context) {
    return Theme.of(context).extension<MoneyColors>()?.hint ?? Colors.black;
  }

  // Text Style Accessors
  static TextStyle getTitleStyle(BuildContext context) {
    return Theme.of(context).extension<MoneyTypography>()?.title.medium ??
        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  }

  static TextStyle getAxisLabelStyle(BuildContext context) {
    return Theme.of(context).extension<MoneyTypography>()?.label.xSmall ??
        const TextStyle(fontSize: 10);
  }

  static TextStyle getTooltipTextStyle(BuildContext context) {
    return Theme.of(context).extension<MoneyTypography>()?.label.xSmall ??
        const TextStyle(fontSize: 10);
  }

  static TextStyle getEmptyStateStyle(BuildContext context) {
    return Theme.of(context).extension<MoneyTypography>()?.body.small ??
        const TextStyle(fontSize: 14);
  }

  // Gradient Colors
  static Color getGradientStartColor(BuildContext context) {
    return getPrimaryColor(context)
        .withValues(alpha: ChartConstants.gradientStartOpacity);
  }

  static Color getGradientEndColor(BuildContext context) {
    return getPrimaryColor(context)
        .withValues(alpha: ChartConstants.gradientEndOpacity);
  }

  // Shadow Configuration
  static List<BoxShadow> getChartShadow(BuildContext context) {
    return [
      BoxShadow(
        color: getShadowColor(context)
            .withValues(alpha: ChartConstants.shadowOpacity),
        spreadRadius: ChartConstants.shadowSpreadRadius,
        blurRadius: ChartConstants.shadowBlurRadius,
      ),
    ];
  }
}
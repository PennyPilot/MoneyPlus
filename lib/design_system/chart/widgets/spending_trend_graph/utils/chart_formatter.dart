import 'package:intl/intl.dart';
import '../../../config/chart_constants.dart';

/// Formatter for chart data display.
///
/// This class follows the Single Responsibility Principle by focusing
/// solely on formatting numbers and dates for chart display.
class ChartFormatter {
  ChartFormatter._();

  /// Formats amount with K/M suffix for compact display in charts.
  ///
  /// Examples:
  /// - 500 → "500"
  /// - 1,500 → "2K"
  /// - 1,500,000 → "1.5M"
  static String formatAmount(double amount) {
    if (amount >= ChartConstants.millionThreshold) {
      return '${(amount / ChartConstants.millionThreshold).toStringAsFixed(1)}M';
    } else if (amount >= ChartConstants.thousandThreshold) {
      return '${(amount / ChartConstants.thousandThreshold).toStringAsFixed(0)}K';
    }
    return amount.toStringAsFixed(0);
  }

  /// Formats a date using the specified pattern.
  ///
  /// Default pattern is 'd MMM' (e.g., "1 Jan").
  static String formatDate(DateTime date, {String pattern = 'd MMM'}) {
    return DateFormat(pattern).format(date);
  }

  /// Formats amount with currency symbol.
  static String formatCurrency(double amount, String currency) {
    return '${formatAmount(amount)} $currency';
  }

  /// Formats full amount with thousand separators for tooltips.
  ///
  /// Uses system locale and removes unnecessary decimal zeros.
  /// Examples:
  /// - 1000.00 → "1,000"
  /// - 1234.56 → "1,234.56"
  static String formatFullAmount(double amount) {
    final formatter = NumberFormat('#,##0.00');
    String formatted = formatter.format(amount);

    // Remove .00 suffix if present
    if (formatted.endsWith('.00')) {
      formatted = formatted.substring(0, formatted.length - 3);
    }

    return formatted;
  }
}
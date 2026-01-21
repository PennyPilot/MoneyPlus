import 'package:intl/intl.dart';

class AmountFormatter {
  AmountFormatter._();

  static const double millionThreshold = 1000000.0;
  static const double thousandThreshold = 1000.0;

  static String formatCompact(double amount) {
    if (amount >= millionThreshold) {
      return '${(amount / millionThreshold).toStringAsFixed(1)}M';
    } else if (amount >= thousandThreshold) {
      return '${(amount / thousandThreshold).toStringAsFixed(0)}K';
    }
    return amount.toStringAsFixed(0);
  }

  static String formatWithCurrency(double amount, String currency) {
    return '${formatFull(amount)} $currency';
  }

  static String formatFull(double amount) {
    final formatter = NumberFormat('#,##0.00');
    String formatted = formatter.format(amount);

    if (formatted.endsWith('.00')) {
      formatted = formatted.substring(0, formatted.length - 3);
    }

    return formatted;
  }
}

import 'package:intl/intl.dart';

class ChartFormatter {
  static String formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toStringAsFixed(0);
  }

  static String formatDate(DateTime date, {String pattern = 'd MMM'}) {
    return DateFormat(pattern).format(date);
  }

  static String formatCurrency(double amount, String currency) {
    return '${formatAmount(amount)} $currency';
  }

  static String formatFullAmount(double amount) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    String formatted = formatter.format(amount);

    if (formatted.endsWith('.00')) {
      formatted = formatted.substring(0, formatted.length - 3);
    }

    return formatted;
  }
}
class NumberFormatter {
  NumberFormatter._();

  static String formatWithCommas(double value) {
    final intValue = value.toInt();
    return intValue.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  static String formatWithCurrency(double value, String currency) {
    return '${formatWithCommas(value)} $currency';
  }
}

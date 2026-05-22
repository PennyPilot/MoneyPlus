import 'dart:math';
import 'package:intl/intl.dart';

String getHiddenBalance(String balance){
  return List.filled(balance.length + 5, '•').join();
}

String formatWithCommas(num value, {int decimalPlaces = 0}) {
  double truncated = value.toDouble();
  if (decimalPlaces > 0) {
    final mod = pow(10, decimalPlaces);
    truncated = (value * mod).truncateToDouble() / mod;
  }

  final String pattern = decimalPlaces > 0 
    ? '#,##0.${'0' * decimalPlaces}' 
    : '#,##0';
    
  final formatter = NumberFormat(pattern);
  return formatter.format(truncated);
}

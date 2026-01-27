import 'package:intl/intl.dart';

String getHiddenBalance(String balance){
  return List.filled(balance.length + 5, '•').join();
}

String formatWithCommas(num value) {
  final formatter = NumberFormat('#,###');
  return formatter.format(value);

}
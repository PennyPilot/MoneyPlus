import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static const String defaultDatePattern = 'd MMM';

  static String format(DateTime date, {String pattern = defaultDatePattern}) {
    return DateFormat(pattern).format(date);
  }
}

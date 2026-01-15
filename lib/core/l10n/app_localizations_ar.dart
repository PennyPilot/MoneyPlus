// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get income => 'الدخل';

  @override
  String get expense => 'المصروف';

  @override
  String moneyAmount(Object amount, Object currency) {
    return '$amount $currency ';
  }
}

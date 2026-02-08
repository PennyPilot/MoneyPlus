import 'package:flutter/cupertino.dart';
import 'package:moneyplus/core/l10n/app_localizations.dart';

String getMonthNameFromNumber(int month, BuildContext context) {
  final localizations = AppLocalizations.of(context)!;
  final x = localizations.date;
  if (month < 1 || month > 12) {
    throw ArgumentError('Month value: "$month" is not valid, Month must be between 1 and 12');
  }

  final months = [
    localizations.month_january,
    localizations.month_february,
    localizations.month_march,
    localizations.month_april,
    localizations.month_may,
    localizations.month_june,
    localizations.month_july,
    localizations.month_august,
    localizations.month_september,
    localizations.month_october,
    localizations.month_november,
    localizations.month_december,
  ];

  return months[month - 1];
}
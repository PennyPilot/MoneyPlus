import 'package:flutter/material.dart';
import 'package:moneyplus/core/l10n/app_localizations.dart';
import 'package:moneyplus/design_system/theme/money_colors.dart';
import 'package:moneyplus/design_system/theme/money_typography.dart';

extension MoneyExtensionContext on BuildContext {
  MoneyTypography get typography =>
      Theme.of(this).extension<MoneyTypography>()!;

  MoneyColors get colors => Theme.of(this).extension<MoneyColors>()!;

  AppLocalizations get localizations => AppLocalizations.of(this)!;
}

import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/theme/money_colors.dart';
import 'package:moneyplus/design_system/theme/money_typography.dart';

class MoneyTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    fontFamily: 'Rubik',
    extensions: const [MoneyColors.light, MoneyTypography.typography],
  );
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    fontFamily: 'Rubik',
    extensions: const [MoneyColors.dark, MoneyTypography.typography],
  );
}

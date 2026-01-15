import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/component/buttons/money_button.dart';
import 'package:moneyplus/design_system/theme/money_colors.dart';

class SMSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final String? iconPath;
  final bool isLoading;
  final bool isEnabled;

  const SMSecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.iconPath,
    this.isLoading = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return MoneyButton(
      text: text,
      onPressed: onPressed,
      iconPath: iconPath,
      isLoading: isLoading,
      isEnabled: isEnabled,
      height: 36,
      backgroundColor: MoneyColors.light.surfaceLow,
      disabledBackgroundColor: MoneyColors.light.disabled,
      textColor: MoneyColors.light.title,
      disabledTextColor: MoneyColors.light.onPrimary,
      hasShadow: false,
      cornerRadius: 100,
      fontSize: 12,
      borderColor:  MoneyColors.light.stroke,
      borderWidth: 0.5,
    );
  }
}
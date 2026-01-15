import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/component/buttons/money_button.dart';
import 'package:moneyplus/design_system/theme/money_colors.dart';

class DefaultButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final String? iconPath;
  final bool isLoading;
  final bool isEnabled;

  const DefaultButton({
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
      backgroundColor: MoneyColors.light.primary,
      disabledBackgroundColor: MoneyColors.light.disabled,
      textColor: MoneyColors.light.onPrimary,
      disabledTextColor: MoneyColors.light.onPrimary,
      hasShadow: true,
      innerShadow: BoxShadow(
        color: const Color(0x80FDECF0),
        offset: const Offset(0, 4),
        blurRadius: 12,
        spreadRadius: 0,
      ),
      outerShadow: BoxShadow(
        color: const Color(0x29DC143C),
        offset: const Offset(0, 4),
        blurRadius: 8,
        spreadRadius: 0,
      ),
    );
  }
}
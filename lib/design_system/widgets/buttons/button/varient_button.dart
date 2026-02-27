import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/widgets/buttons/money_button.dart';
import 'package:moneyplus/design_system/theme/money_colors.dart';

class VarientButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final String? iconPath;
  final bool isLoading;
  final bool isEnabled;

  const VarientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.iconPath,
    this.isLoading = false,
    this.isEnabled = true,
  });

  @override
  State<VarientButton> createState() => _VarientButtonState();
}

class _VarientButtonState extends State<VarientButton> {
  @override
  Widget build(BuildContext context) {
    return MoneyButton(
      text: widget.text,
      onPressed: widget.onPressed,
      iconPath: widget.iconPath,
      isLoading: widget.isLoading,
      isEnabled: widget.isEnabled,
      cornerRadius: 100,
      fontSize: 12,
      height: 36,
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
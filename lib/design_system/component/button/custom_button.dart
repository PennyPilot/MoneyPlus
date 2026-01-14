import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/theme/money_colors.dart';

class MButton extends StatelessWidget {
  final double cornerRadius;
  final Color backgroundColor;
  final Color textColor;
  final String text;
  final double fontSize;
  final VoidCallback? onPressed;
  final Color? borderColor;
  final double borderWidth;
  final IconData? icon;
  final double height;

  const MButton({
    super.key,
    this.cornerRadius = 16,
    required this.backgroundColor,
    required this.textColor,
    required this.text,
    this.fontSize = 16,
    this.onPressed,
    this.borderColor,
    this.borderWidth = 0.5,
    this.icon,
    this.height = 52
  });

  factory MButton.defult({
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
  }) {
    return MButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      backgroundColor: MoneyColors.light.primary,
      textColor: MoneyColors.light.onPrimary,
    );
  }

  factory MButton.variant({
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
  }) {
    return MButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      backgroundColor: MoneyColors.light.primary,
      textColor: MoneyColors.light.onPrimary,
      cornerRadius: 100,
      height: 36,
    );
  }

  factory MButton.disabled({required String text, IconData? icon, VoidCallback? onPressed }) {
    return MButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      backgroundColor: MoneyColors.light.disabled,
      textColor: MoneyColors.light.onPrimary,
    );
  }

  factory MButton.defultSecondary({
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
  }) {
    return MButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      backgroundColor: MoneyColors.light.surfaceLow,
      textColor: MoneyColors.light.title,
      borderColor: MoneyColors.light.stroke,
      borderWidth: 0.5,
    );
  }

  factory MButton.variantSecondary({
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
  }) {
    return MButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      backgroundColor: MoneyColors.light.disabled,
      textColor: MoneyColors.light.onPrimary,
      cornerRadius: 100,
      borderColor: MoneyColors.light.stroke,
      borderWidth: 0.5,
      height: 36,
    );
  }

  factory MButton.disabledSecondary({required String text, IconData? icon,VoidCallback? onPressed}) {
    return MButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      backgroundColor: MoneyColors.light.surfaceLow,
      textColor: MoneyColors.light.title,
      cornerRadius: 100,
      borderColor: MoneyColors.light.stroke,
      borderWidth: 0.5,
    );
  }

  factory MButton.defultError({required String text, IconData? icon, VoidCallback? onPressed}) {
    return MButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      backgroundColor: MoneyColors.light.redVariant,
      textColor: MoneyColors.light.red,
      borderColor: MoneyColors.light.stroke,
      borderWidth: 0.5,
    );
  }

factory MButton.variantError({required String text, IconData? icon, VoidCallback? onPressed}) {
    return MButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      backgroundColor: MoneyColors.light.disabled,
      textColor: MoneyColors.light.onPrimary,
      borderColor: MoneyColors.light.stroke,
      borderWidth: 0.5,
    );
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          disabledBackgroundColor: backgroundColor,
          disabledForegroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cornerRadius),
            side: borderColor != null && borderColor != Colors.transparent
                ? BorderSide(color: borderColor!, width: borderWidth)
                : BorderSide.none,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, size: 18, color: textColor),
            ],
          ],
        ),
      ),
    );
  }
}

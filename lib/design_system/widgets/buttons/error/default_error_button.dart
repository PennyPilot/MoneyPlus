import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/buttons/money_button.dart';

class DefaultErrorButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final String? iconPath;
  final bool isLoading;
  final bool isEnabled;

  const DefaultErrorButton({
    super.key,
    required this.text,
    this.onPressed,
    this.iconPath,
    this.isLoading = false,
    this.isEnabled = true,
  });

  @override
  State<DefaultErrorButton> createState() => _DefaultErrorButtonState();
}

class _DefaultErrorButtonState extends State<DefaultErrorButton> {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return MoneyButton(
      text: widget.text,
      onPressed: widget.onPressed,
      iconPath: widget.iconPath,
      isLoading: widget.isLoading,
      isEnabled: widget.isEnabled,
      backgroundColor: colors.redVariant,
      disabledBackgroundColor: colors.disabled,
      textColor: colors.red,
      disabledTextColor: colors.onPrimary,
      hasShadow: false,
      fontSize: 14,
      borderColor: colors.stroke,
      borderWidth: 0.5,
    );
  }
}

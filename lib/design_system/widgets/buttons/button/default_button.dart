import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/buttons/money_button.dart';

class DefaultButton extends StatefulWidget {
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
  State<DefaultButton> createState() => _DefaultButtonState();
}

class _DefaultButtonState extends State<DefaultButton> {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return MoneyButton(
      text: widget.text,
      onPressed: widget.onPressed,
      iconPath: widget.iconPath,
      isLoading: widget.isLoading,
      isEnabled: widget.isEnabled,
      backgroundColor: colors.primary,
      disabledBackgroundColor: colors.disabled,
      textColor: colors.onPrimary,
      disabledTextColor: colors.onPrimary,
      hasShadow: true,
      innerShadow: BoxShadow(
        color: colors.primary.withValues(alpha: 0.5),
        offset: const Offset(0, 4),
        blurRadius: 12,
        spreadRadius: 0,
        blurStyle: BlurStyle.inner,
      ),
      outerShadow: BoxShadow(
        color: colors.defaultButtonShadow,
        offset: const Offset(0, 4),
        blurRadius: 8,
        spreadRadius: 0,
        blurStyle: BlurStyle.outer,
      ),
    );
  }
}

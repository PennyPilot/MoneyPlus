import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/buttons/button/default_button.dart';

class CategoryBottomBar extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const CategoryBottomBar({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      color: colors.surfaceLow,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 19),
          child: DefaultButton(text: buttonText, onPressed: onPressed),
        ),
      ),
    );
  }
}

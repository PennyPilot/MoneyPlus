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
      height: 84,
      color: colors.surfaceLow,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: DefaultButton(text: buttonText, onPressed: onPressed),
      ),
    );
  }
}

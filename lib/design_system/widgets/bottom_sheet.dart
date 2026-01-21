import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/theme/money_colors.dart';
import 'package:moneyplus/design_system/theme/money_typography.dart';

class BottomSheet extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actionButtons;

  const BottomSheet({
    super.key,
    required this.title,
    required this.content,
    required this.actionButtons,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: MoneyTypography.typography.title.small.copyWith(
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: MoneyColors.light.body, width: 1),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: MoneyColors.light.body,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Divider(thickness: 1, color: MoneyColors.light.stroke),
          const SizedBox(height: 12),

          content,
          const SizedBox(height: 24),

          if (actionButtons.isNotEmpty)
            Row(
              children: [
                for (int i = 0; i < actionButtons.length; i++) ...[
                  Expanded(child: actionButtons[i]),
                  if (i < actionButtons.length - 1) const SizedBox(width: 12),
                ],
              ],
            ),

          SizedBox(height: 24),
        ],
      ),
    );
  }
}

void showCustomBottomSheet({
  required BuildContext context,
  required String title,
  required Widget content,
  required List<Widget> actionButtons,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: BottomSheet(
        title: title,
        content: content,
        actionButtons: actionButtons,
      ),
    ),
  );
}

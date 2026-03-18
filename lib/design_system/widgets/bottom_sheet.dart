import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:svg_flutter/svg.dart';

import '../theme/money_extension_context.dart';

class MBottomSheet extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actionButtons;

  const MBottomSheet({
    super.key,
    required this.title,
    required this.content,
    required this.actionButtons,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.only(
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
                style: typography.title.small.copyWith(
                  color: colors.title,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset(
                  AppAssets.iconCancel,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(colors.title, BlendMode.srcIn),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(thickness: 1, color: colors.stroke),
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
          const SizedBox(height: 24),
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
      child: MBottomSheet(
        title: title,
        content: content,
        actionButtons: actionButtons,
      ),
    ),
  );
}

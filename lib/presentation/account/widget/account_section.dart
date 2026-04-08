import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';

Widget accountSection(
  BuildContext context, {
  required String title,
  required String iconPath,
  bool showDivider = true,
  VoidCallback? onTap,
}) {
  final colors = context.colors;
  final typography = context.typography;

  return InkWell(
    onTap: onTap,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: colors.surfaceHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 11),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                iconPath,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(colors.primary, BlendMode.srcIn),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: typography.label.large.copyWith(
                color: colors.title,
              ),
            ),
          ],
        ),
        if (showDivider)
          Divider(color: colors.stroke, thickness: 0.5),
      ],
    ),
  );
}

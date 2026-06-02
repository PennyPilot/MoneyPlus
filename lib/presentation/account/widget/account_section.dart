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

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: colors.surfaceHigh,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 11),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    iconPath,
                    width: 24,
                    height: 24,
                    colorFilter:
                        ColorFilter.mode(colors.primary, BlendMode.srcIn),
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
          ),
        ),
      ),
      if (showDivider)
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 8),
          child: Divider(
            color: colors.stroke,
            thickness: 0.5,
            height: 1,
          ),
        ),
    ],
  );
}

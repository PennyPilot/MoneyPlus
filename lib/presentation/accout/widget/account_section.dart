import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../design_system/theme/money_colors.dart';
import '../../../design_system/theme/money_typography.dart';

Widget accountSection({
  required String title,
  required String iconPath,
  bool showDivider = true,
  VoidCallback? onTap,
}) {
  return InkWell(
    onTap: () {
      if (onTap != null) {
        onTap();
      }
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: MoneyColors.light.surfaceHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 11),
              alignment: Alignment.center,
              child: SvgPicture.asset(iconPath, width: 24, height: 24),
            ),
            SizedBox(width: 8),
            Text(
              title,
              style: MoneyTypography.typography.label.large.copyWith(
                color: MoneyColors.light.title,
              ),
            ),
          ],
        ),
        if (showDivider)
          Divider(color: MoneyColors.light.stroke, thickness: 0.5),
      ],
    ),
  );
}

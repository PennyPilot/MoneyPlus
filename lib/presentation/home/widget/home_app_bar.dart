import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import '../../../design_system/assets/app_assets.dart';
import '../../../design_system/theme/money_colors.dart';
import '../../../design_system/theme/money_typography.dart';
import '../../../design_system/utils/helpers.dart';

Widget homeAppBar({
  required int month,
  required int year,
  required Function onClickDateChip,
  required BuildContext context,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      GestureDetector(
        onTap: (){ onClickDateChip(); },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: MoneyColors.light.surface,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${getMonthNameFromNumber(month,context)}, $year",
                style: MoneyTypography.typography.label.small.copyWith(
                  color: MoneyColors.light.title,
                ),
              ),
              SvgPicture.asset(AppAssets.arrowDownV2),
            ],
          ),
        ),
      ),
      SvgPicture.asset(AppAssets.appBrand),
    ],
  );
}

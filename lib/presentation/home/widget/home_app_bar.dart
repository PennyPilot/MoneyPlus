import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneyplus/presentation/home/cubit/home_cubit.dart';
import '../../../design_system/assets/app_assets.dart';
import '../../../design_system/theme/money_colors.dart';
import '../../../design_system/theme/money_typography.dart';
import '../../../domain/repository/model/month_enum.dart';

Widget homeAppBar({
  required Month month,
  required int year,
  required Function onClickDateChip
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
                "${month.label}, $year",
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

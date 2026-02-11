import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneyplus/presentation/widgets/drop_down_date_dialog.dart';
import '../../../design_system/assets/app_assets.dart';

Widget homeAppBar({
  required int month,
  required int year,
  required Function(DateTime) onDatePick,
  required BuildContext context,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      DropDownDateDialog(onDatePick: onDatePick, year: year, month: month),
      SvgPicture.asset(AppAssets.appBrand),
    ],
  );
}

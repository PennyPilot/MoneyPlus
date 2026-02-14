import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../design_system/assets/app_assets.dart';
import '../../design_system/theme/money_extension_context.dart';
import '../../design_system/utils/helpers.dart';
import '../../design_system/widgets/custom_date_picker.dart';

class DropDownDateDialog extends StatelessWidget {
  final Function(DateTime) onDatePick;
  final int year;
  final int month;

  const DropDownDateDialog({
    super.key,
    required this.onDatePick,
    required this.year,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    return GestureDetector(
      onTap: () async {
        final picked = await showMonthYearDialog(
          context,
          initialMonth: month,
          initialYear: year,
        );
        if (picked != null) {
          onDatePick(picked);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${getMonthNameFromNumber(month, context)}, $year",
              style: typography.label.small.copyWith(color: colors.title),
            ),
            SvgPicture.asset(AppAssets.arrowDownV2),
          ],
        ),
      ),
    );
  }
}

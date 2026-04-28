import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/app_bar.dart';
import 'package:moneyplus/presentation/widgets/drop_down_date_dialog.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../design_system/assets/app_assets.dart';

class TransactionAppBar extends StatelessWidget {
  final Function(int month, int year) onDatePick;
  final VoidCallback onFilterClicked;
  final int year;
  final int month;

  const TransactionAppBar({
    super.key,
    required this.onDatePick,
    required this.onFilterClicked,
    required this.year,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final localizations = AppLocalizations.of(context)!;

    return CustomAppBar(
      title: localizations.transaction,
      backgroundColor: colors.surfaceLow,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropDownDateDialog(onDatePick: (date) {
            onDatePick(date.month, date.year);
          }, year: year, month: month),
          SizedBox(width: 8,),
          GestureDetector(
            onTap: onFilterClicked,
            child: Container(
              height: 40,
              width: 40,
              alignment: AlignmentGeometry.center,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(100),
              ),
              child: SvgPicture.asset(
                AppAssets.icFilter,
                colorFilter: ColorFilter.mode(colors.title,BlendMode.srcIn),
                height: 20, width: 20,),
            ),
          ),
        ],
      ),
    );
  }
}

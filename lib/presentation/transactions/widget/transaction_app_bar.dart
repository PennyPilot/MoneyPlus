import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/app_bar.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../design_system/assets/app_assets.dart';
import '../cubit/transaction_state.dart';

class TransactionAppBar extends StatelessWidget {
  final Function onClickDateChip;
  final Function onFilterClicked;
  final int year;
  final Month month;

  const TransactionAppBar({
    super.key,
    required this.onClickDateChip,
    required this.onFilterClicked,
    required this.year,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final localizations = AppLocalizations.of(context)!;

    return CustomAppBar(
      title: localizations.transaction,
      backgroundColor: colors.surfaceLow,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              onClickDateChip();
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
                    "${month.label}, $year",
                    style: typography.label.small.copyWith(color: colors.title),
                  ),
                  SvgPicture.asset(AppAssets.arrowDownV2),
                ],
              ),
            ),
          ),
          SizedBox(width: 8,),
          GestureDetector(
            onTap: () { },
            child: Container(
              height: 40,
              width: 40,
              alignment: AlignmentGeometry.center,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(100),
              ),
              child: SvgPicture.asset(AppAssets.icFilter, height: 20, width: 20,),
            ),
          ),
        ],
      ),
    );
  }
}

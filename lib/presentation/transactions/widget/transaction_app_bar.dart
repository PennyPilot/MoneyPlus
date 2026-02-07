import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/app_bar.dart';

import '../../../design_system/assets/app_assets.dart';
import '../cubit/transaction_state.dart';

class TransactionAppBar extends StatelessWidget {
  final Function onClickDateChip;
  final int year;
  final Month month;

  const TransactionAppBar({
    super.key,
    required this.onClickDateChip,
    required this.year,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    return CustomAppBar(
      title: "Transaction",
      backgroundColor: colors.surfaceLow,
      trailing: GestureDetector(
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
    );
  }
}

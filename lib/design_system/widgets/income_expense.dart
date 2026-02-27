import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/l10n/app_localizations.dart';
import '../assets/app_assets.dart';
import '../theme/money_extension_context.dart';

enum IncomeExpenseType { income, expense }

class IncomeExpense extends StatelessWidget {
  final IncomeExpenseType type;
  final String amount;
  final String currency;

  const IncomeExpense({
    super.key,
    required this.type,
    required this.amount,
    this.currency = 'IQD',
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final l10n = AppLocalizations.of(context)!;

    final isIncome = type == IncomeExpenseType.income;

    final label = isIncome ? l10n.income : l10n.expense;
    final Color operationColor = isIncome ? colors.green : colors.red;
    final Color backgroundColor = isIncome
        ? colors.greenVariant
        : colors.redVariant;
    final String iconPath = isIncome
        ? AppAssets.icArrowDown
        : AppAssets.icArrowUp;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceLow,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: SvgPicture.asset(
              iconPath,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(operationColor, BlendMode.srcIn),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 4, 10, 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: typography.label.xSmall?.copyWith(color: colors.body),
                  ),
                  Row(
                    children: [
                      Text(
                        isIncome ? '+' : '-',
                        style: typography.title.medium.copyWith(
                          color: operationColor,
                        ),
                      ),
                      Expanded(
                        child: Text(
                            l10n.moneyAmount(
                              amount,
                              currency
                            ),
                          style: TextStyle(
                            color: colors.title,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

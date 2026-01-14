import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/money_extension_context.dart';

enum IncomeExpenseType { income, expense }

class IncomeExpense extends StatelessWidget {
  final IncomeExpenseType type;
  final String label;
  final String amount;

  const IncomeExpense({
    super.key,
    required this.type,
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    final isIncome = type == IncomeExpenseType.income;

    final Color operationColor = isIncome ? colors.green : colors.red;
    final Color backgroundColor = isIncome
        ? colors.greenVariant
        : colors.redVariant;

    final String iconPath = isIncome
        ? 'assets/icons/ic_arrow_down.svg'
        : 'assets/icons/ic_arrow_up.svg';

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
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
          Padding(
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
                    const SizedBox(width: 2),
                    Text(
                      '$amount IQD ',
                      style: TextStyle(
                        color: colors.title,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

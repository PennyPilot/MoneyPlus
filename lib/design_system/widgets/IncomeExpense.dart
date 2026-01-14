import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/design_system/theme/money_colors.dart';

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
    final colors = Theme.of(context).extension<MoneyColors>();
    if (colors == null) {
      return const SizedBox();
    }

    final isIncome = type == IncomeExpenseType.income;

    final Color operationColor = isIncome ? colors.green : colors.red;
    final Color backgroundColor = isIncome
        ? colors.greenVariant
        : colors.redVariant;

    final String iconPath = isIncome
        ? 'assets/icons/ic_arrow_down.svg'
        : 'assets/icons/ic_arrow_up.svg';

    return Container(
      height: 44,
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
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: SvgPicture.asset(
              iconPath,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(operationColor, BlendMode.srcIn),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: colors.body,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                children: [
                  Text(
                    isIncome ? '+' : '-',
                    style: TextStyle(
                      color: operationColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
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
                  const SizedBox(width: 4),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

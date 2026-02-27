import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';

class TopSpendingCard extends StatelessWidget {
  final String expenseCategory;
  final String amount;
  final int transactionCount;
  final double percentage;

  const TopSpendingCard({
    super.key,
    required this.expenseCategory,
    required this.amount,
    required this.transactionCount,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              expenseCategory,
              style: context.typography.label.medium.copyWith(color: context.colors.title),
            ),
            Text(
              amount,
              style: context.typography.label.medium.copyWith(color: context.colors.title),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$transactionCount transaction",
              style: context.typography.label.small.copyWith(color: context.colors.hint),
            ),
            Text(
              "${_formatPercentage(percentage)}%",
              style: context.typography.label.small.copyWith(color: context.colors.hint),
            ),
          ],
        ),
      ],
    );
  }
}

String _formatPercentage(double value) {
  return value.round().toString();
}

import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';

Widget topSpendingCard({
  required BuildContext context,
  required String expenseCategory,
  required String amount,
  required int transactionCount,
  required double percentage
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        children: [
          Text(
            expenseCategory,
            style: context.typography.label.medium.copyWith(color: context.colors.title),
          ),
          Spacer(),
          Text(
            amount,
            style: context.typography.label.medium.copyWith(color: context.colors.title),
          ),
        ],
      ),
      Row(
        children: [
          Text(
            "$transactionCount transaction",
            style: context.typography.label.small.copyWith(color: context.colors.hint),
          ),
          Spacer(),
          Text(
            "${_formatPercentage(percentage)}%",
            style: context.typography.label.small.copyWith(color: context.colors.hint),
          ),
        ],
      ),
    ],
  );
}

String _formatPercentage(double value) {
  if (value % 1 == 0) {
    return value.toInt().toString();
  }
  return value.toString();
}

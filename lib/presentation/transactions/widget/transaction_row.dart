import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/domain/entity/transaction_type.dart';

class TransactionRow extends StatelessWidget {
  final TransactionType transactionType;
  final String category;
  final String currency;
  final double amount;
  final DateTime date;

  const TransactionRow({
    super.key,
    required this.transactionType,
    required this.category,
    required this.currency,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          category,
          style: context.typography.label.medium.copyWith(
            color: context.colors.title,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  transactionType == TransactionType.income ? "+" : "-",
                  style: context.typography.label.medium.copyWith(
                    color: transactionType == TransactionType.income
                        ? context.colors.green
                        : context.colors.red,
                  ),
                ),
                Text(
                  NumberFormat('#,##0').format(amount),
                  style: context.typography.label.medium.copyWith(
                    color: context.colors.title,
                  ),
                ),
                Text(
                  " $currency",
                  style: context.typography.label.medium.copyWith(
                    color: context.colors.title,
                  ),
                ),
              ],
            ),
            Text(
              DateFormat('dd MMM yyyy').format(date),
              style: context.typography.label.small.copyWith(
                color: context.colors.hint,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

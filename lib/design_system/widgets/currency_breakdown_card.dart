import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';

class CurrencyBreakdownCard extends StatelessWidget {
  final String currencyName;
  final String abbreviation;
  final String amount;
  final int transactionCount;

  const CurrencyBreakdownCard({
    super.key,
    required this.currencyName,
    required this.abbreviation,
    required this.amount,
    required this.transactionCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              currencyName,
              style: context.typography.label.medium.copyWith(color: context.colors.title),
            ),
            Text(
              amount,
              style: context.typography.label.medium.copyWith(color: context.colors.title),
            ),
          ],
        ),

        Text(
          "$transactionCount ${context.localizations.transaction_unit}",
          style: context.typography.label.small.copyWith(color: context.colors.hint),
        ),
      ],
    );
  }
}

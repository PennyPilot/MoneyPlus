import 'package:flutter/material.dart';
import 'package:moneyplus/core/utils/number_formatter.dart';
import 'package:moneyplus/design_system/constants/design_constants.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';

class SummaryItem extends StatelessWidget {
  final Widget icon;
  final String label;
  final double value;
  final String currency;
  final bool isIncome;

  const SummaryItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.currency,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColors = isIncome
        ? GradientColors.incomeGradient
        : GradientColors.expenseGradient;

    return Row(
      children: [
        Container(
          width: DesignConstants.summaryIconContainerSize,
          height: DesignConstants.summaryIconContainerSize,
          decoration: BoxDecoration(
            color: isIncome
                ? context.colors.secondaryVariant
                : context.colors.primaryVariant,
            borderRadius: BorderRadius.circular(DesignConstants.radiusSmall),
          ),
          alignment: Alignment.center,
          child: icon,
        ),
        const SizedBox(width: DesignConstants.spacingSmall),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: DesignConstants.indicatorCircleSize,
                    height: DesignConstants.indicatorCircleSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: gradientColors,
                      ),
                    ),
                  ),
                  const SizedBox(width: DesignConstants.spacingXSmall),
                  Text(
                    label,
                    style: context.typography.label.xSmall?.copyWith(
                      color: isIncome
                          ? context.colors.secondary
                          : context.colors.primary,
                    ),
                  ),
                ],
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: isIncome ? '+' : '-',
                      style: context.typography.label.medium.copyWith(
                        color: isIncome
                            ? context.colors.green
                            : context.colors.primary,
                      ),
                    ),
                    TextSpan(
                      text: NumberFormatter.formatWithCurrency(value, currency),
                      style: context.typography.label.medium.copyWith(
                        color: context.colors.title,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

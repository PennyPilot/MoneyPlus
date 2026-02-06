import 'package:flutter/material.dart';
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

  String _formatNumber(double value) {
    final intValue = value.toInt();
    return intValue.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    // Linear gradient colors for the circle indicator
    final List<Color> gradientColors = isIncome
        ? [const Color(0xFF0496AD), const Color(0xFF097C8E)]
        : [const Color(0xFFDC143C), const Color(0xFFA01A35)];

    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isIncome ? colors.secondaryVariant : colors.primaryVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: icon,
        ),
        const SizedBox(width: 8),

        // Text Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Label Row with gradient circle indicator
              Row(
                children: [
                  // Gradient Circle Indicator
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: gradientColors,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Label - Secondary/Primary color, Label/XSmall
                  Text(
                    label,
                    style: typography.label.xSmall?.copyWith(
                      color: isIncome ? colors.secondary : colors.primary,
                    ),
                  ),
                ],
              ),

              // Amount Row
              RichText(
                text: TextSpan(
                  children: [
                    // Sign (+/-) with specific color
                    TextSpan(
                      text: isIncome ? '+' : '-',
                      style: typography.label.medium.copyWith(
                        color: isIncome ? colors.green : colors.primary,
                      ),
                    ),
                    // Amount - Label/Medium with Title color
                    TextSpan(
                      text: '${_formatNumber(value)} $currency',
                      style: typography.label.medium.copyWith(
                        color: colors.title,
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

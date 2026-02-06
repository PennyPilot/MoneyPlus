import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';

class ScaleLabels extends StatelessWidget {
  final double maxValue;

  const ScaleLabels({
    super.key,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    final labels = ['0', '15K', '50K', '150K', '300K', '600K', '1M', '1.5M', '2M'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: labels.map((label) {
        return Text(
          label,
          style: typography.label.xSmall?.copyWith(
            color: colors.hint,
          ),
        );
      }).toList(),
    );
  }
}
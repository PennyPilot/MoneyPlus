import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';

class OverviewScaleLabels extends StatelessWidget {
  final List<String> labels;

  const OverviewScaleLabels({super.key, required this.labels});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: labels
          .map(
            (label) => Text(
              label,
              style: context.typography.label.xSmall?.copyWith(
                color: context.colors.body,
              ),
            ),
          )
          .toList(),
    );
  }
}

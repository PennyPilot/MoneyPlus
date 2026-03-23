import 'package:flutter/material.dart';
import 'package:moneyplus/core/l10n/app_localizations.dart';
import 'package:moneyplus/design_system/constants/design_constants.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';

import '../../../domain/entity/spending_trend_point.dart';

class HighestSpendingBanner extends StatelessWidget {
  final SpendingTrend trend;

  const HighestSpendingBanner({super.key, required this.trend});

  @override
  Widget build(BuildContext context) {
    if (trend.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final peak = trend.points.reduce((a, b) => a.amount >= b.amount ? a : b);
    final day = peak.date.day;
    final monthAbbr = _monthAbbr(peak.date.month);

    return Container(
      height: DesignConstants.savingsBannerHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: DesignConstants.spacingSmall,
      ),
      decoration: BoxDecoration(
        color: context.colors.redVariant,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(DesignConstants.radiusMedium),
          bottomRight: Radius.circular(DesignConstants.radiusMedium),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 12,
            color: context.colors.primary,
          ),
          const SizedBox(width: DesignConstants.spacingXSmall),
          Text(
            l10n.highest_spending_message('$day $monthAbbr'),
            style: context.typography.label.xSmall?.copyWith(
              color: context.colors.red,
            ),
          ),
        ],
      ),
    );
  }

  String _monthAbbr(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}

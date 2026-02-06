import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../design_system/assets/app_assets.dart';
import 'progress_bar_section.dart';
import 'savings_banner.dart';
import 'scale_labels.dart';
import 'summary_card.dart';

class MonthlyOverview extends StatelessWidget {
  final double income;
  final double expenses;
  final String currency;
  final double maxValue;

  const MonthlyOverview({
    super.key,
    required this.income,
    required this.expenses,
    this.currency = 'IQD',
    this.maxValue = 2000000,
  });

  double get savings => income - expenses;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colors.surfaceLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Text(
            AppLocalizations.of(context)!.monthly_overview,
            style: context.typography.label.medium.copyWith(
              color: context.colors.title,
            ),
          ),
          const SizedBox(height: 12),

          // Income & Expenses Cards
          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  icon: SvgPicture.asset(
                    AppAssets.icWalletAdd,
                    width: 24,
                    height: 24,
                  ),
                  iconBackgroundColor: const Color(0xFF00BFA5),
                  label: 'Income',
                  value: income,
                  currency: currency,
                  isPositive: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SummaryCard(
                  icon: SvgPicture.asset(
                    AppAssets.icMoneyRemove,
                    width: 24,
                    height: 24,
                  ),
                  iconBackgroundColor: const Color(0xFFE91E63),
                  label: 'Expenses',
                  value: expenses,
                  currency: currency,
                  isPositive: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Progress Bars
          ProgressBarSection(
            income: income,
            expenses: expenses,
            maxValue: maxValue,
          ),
          const SizedBox(height: 8),

          // Scale
          ScaleLabels(maxValue: maxValue),
          const SizedBox(height: 16),

          // Savings Banner
          if (savings > 0) SavingsBanner(savings: savings, currency: currency),
        ],
      ),
    );
  }
}

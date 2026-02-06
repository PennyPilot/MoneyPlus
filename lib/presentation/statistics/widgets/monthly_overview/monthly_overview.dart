import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../design_system/assets/app_assets.dart';
import 'progress_bar_section.dart';
import 'savings_banner.dart';
import 'scale_labels.dart';
import 'summary_item.dart';

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
    final colors = context.colors;
    final typography = context.typography;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main Container
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.surfaceLow,
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Text(
                l10n.monthly_overview,
                style: typography.label.medium.copyWith(
                  color: colors.title,
                ),
              ),
              const SizedBox(height: 12),

              // Income & Expenses Items
              Row(
                children: [
                  Expanded(
                    child: SummaryItem(
                      icon: SvgPicture.asset(
                        AppAssets.icWalletAdd,
                        width: 16,
                        height: 16,
                      ),
                      label: l10n.income,
                      value: income,
                      currency: currency,
                      isIncome: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SummaryItem(
                      icon: SvgPicture.asset(
                        AppAssets.icMoneyRemove,
                        width: 16,
                        height: 16,
                      ),
                      label: l10n.expense,
                      value: expenses,
                      currency: currency,
                      isIncome: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Progress Bars
              ProgressBarSection(
                income: income,
                expenses: expenses,
                maxValue: maxValue,
              ),
              const SizedBox(height: 6),

              // Scale Labels
              ScaleLabels(maxValue: maxValue),
            ],
          ),
        ),

        // Savings Banner - Outside the main container, at the bottom
        if (savings > 0)
          SavingsBanner(
            savings: savings,
            currency: currency,
          ),
      ],
    );
  }
}
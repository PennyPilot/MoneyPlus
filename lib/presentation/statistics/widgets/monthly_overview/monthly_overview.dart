import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          const Text(
            'Monthly Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

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

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneyplus/core/l10n/app_localizations.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/constants/design_constants.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import '../../../../domain/entity/monthly_overview.dart';
import '../section_empty_view.dart';
import 'overview_progress_bar.dart';
import 'overview_savings_banner.dart';
import 'overview_scale_labels.dart';
import 'summary_item.dart';

class MonthlyOverviewSection extends StatelessWidget {
  final MonthlyOverview overview;

  const MonthlyOverviewSection({super.key, required this.overview});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (overview.isEmpty) {
      return SectionEmptyView(
        title: l10n.monthly_overview,
        message: l10n.no_monthly_overview,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Content(overview: overview),
        if (overview.hasSavings)
          OverviewSavingsBanner(
            savings: overview.savings,
            currency: overview.currency,
          ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final MonthlyOverview overview;

  const _Content({required this.overview});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(DesignConstants.spacingMedium),
      decoration: BoxDecoration(
        color: context.colors.surfaceLow,
        borderRadius: const BorderRadius.all(
          Radius.circular(DesignConstants.radiusMedium),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.monthly_overview,
            style: context.typography.label.medium.copyWith(
              color: context.colors.title,
            ),
          ),
          const SizedBox(height: DesignConstants.spacingMedium),
          Row(
            children: [
              Expanded(
                child: SummaryItem(
                  icon: SvgPicture.asset(
                    AppAssets.icWalletAdd,
                    width: DesignConstants.iconSizeMedium,
                    height: DesignConstants.iconSizeMedium,
                  ),
                  label: l10n.income,
                  value: overview.income,
                  currency: overview.currency,
                  isIncome: true,
                ),
              ),
              const SizedBox(width: DesignConstants.spacingXLarge),
              Expanded(
                child: SummaryItem(
                  icon: SvgPicture.asset(
                    AppAssets.icMoneyRemove,
                    width: DesignConstants.iconSizeMedium,
                    height: DesignConstants.iconSizeMedium,
                  ),
                  label: l10n.expense,
                  value: overview.expenses,
                  currency: overview.currency,
                  isIncome: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignConstants.spacingXLarge),
          OverviewProgressBar(overview: overview),
          const SizedBox(height: DesignConstants.spacingMedium),
          OverviewScaleLabels(labels: overview.scaleLabels),
        ],
      ),
    );
  }
}

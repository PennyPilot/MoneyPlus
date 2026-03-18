import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/core/l10n/app_localizations.dart';
import 'package:moneyplus/core/utils/number_formatter.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/constants/design_constants.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';

class OverviewSavingsBanner extends StatelessWidget {
  final double savings;
  final String currency;

  const OverviewSavingsBanner({
    super.key,
    required this.savings,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: DesignConstants.savingsBannerHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: DesignConstants.spacingSmall,
      ),
      decoration: BoxDecoration(
        color: context.colors.secondaryVariant,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(DesignConstants.radiusMedium),
          bottomRight: Radius.circular(DesignConstants.radiusMedium),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppAssets.icCelebrate,
            width: DesignConstants.iconSizeSmall,
            height: DesignConstants.iconSizeSmall,
            colorFilter: ColorFilter.mode(
              context.colors.secondary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: DesignConstants.spacingXSmall),
          Text(
            l10n.savings_message(
              NumberFormatter.formatWithCommas(savings),
              currency,
            ),
            style: context.typography.label.xSmall?.copyWith(
              color: context.colors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

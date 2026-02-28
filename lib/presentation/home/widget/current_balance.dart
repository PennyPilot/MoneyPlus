import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import '../utils/StringFormattingHelpers.dart';

class CurrentBalanceCard extends StatefulWidget {
  const CurrentBalanceCard({
    super.key,
    required this.balance,
    required this.percentage,
  });

  final String balance;
  final double percentage;

  @override
  State<StatefulWidget> createState() {
    return _CurrentBalanceCardState();
  }
}

class _CurrentBalanceCardState extends State<CurrentBalanceCard> {
  var showBalance = true;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final l10n = context.localizations;

    var balanceVisibilityIcon = showBalance ? AppAssets.openEye : AppAssets.closedEye;
    var balance = showBalance ? widget.balance : getHiddenBalance(widget.balance);
    var topPadding = showBalance ? 0.0 : 4.0;
    var percentageIcon = widget.percentage > 0 ? AppAssets.tradeUp : AppAssets.tradeDown;
    var percentageText = widget.percentage > 0 ? l10n.saving : l10n.spending;
    var percentageColor = widget.percentage > 0 ? colors.green : colors.red;

    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.current_balance,
            style: typography.label.small.copyWith(
              color: colors.body,
            ),
          ),
          Row(
            spacing: 8,
            children: [
              Text(
                balance,
                style: typography.headline.small.copyWith(
                  color: colors.title,
                ),
              ),
              GestureDetector(
                onTap: (){triggerBalanceVisibility();},
                child: Container(
                  padding: EdgeInsets.only(top: topPadding),
                  alignment: Alignment.center,
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colors.stroke,
                      width: 1,
                    ),
                  ),
                  child: SvgPicture.asset(
                      balanceVisibilityIcon,
                      height: 16,
                      width: 16,
                      colorFilter: ColorFilter.mode(colors.title, BlendMode.srcIn)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            spacing: 4,
            children: [
              SvgPicture.asset(percentageIcon, width: 16, height: 16),
              Text(
                "${_formatPercentage(widget.percentage)}% $percentageText",
                style: typography.label.xSmall?.copyWith(
                  color: percentageColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void triggerBalanceVisibility() {
    setState(() {
      showBalance = !showBalance;
    });
  }
}

String _formatPercentage(double value) {
  return value.round().toString();
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/theme/money_colors.dart';
import 'package:moneyplus/design_system/theme/money_typography.dart';
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
    final colors = MoneyColors.light;
    final typography = MoneyTypography.typography;
    var balanceIcon = showBalance ? AppAssets.openEye : AppAssets.closedEye;
    var balance = showBalance ? widget.balance : getHiddenBalance(widget.balance);
    var topPadding = showBalance ? 0.0 : 4.0;
    var percentageIcon = widget.percentage > 0 ? AppAssets.tradeUp : AppAssets.tradeDown;
    var percentageText = widget.percentage > 0 ? 'Saving' : 'Spending';
    var percentageColor = widget.percentage > 0 ? colors.green : colors.red;

    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Current Balance",
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
                      color: Color(0xFF1F1F1F).withAlpha((0.1*255).round()),
                      width: 1,
                    ),
                  ),
                  child: SvgPicture.asset(balanceIcon, height: 16, width: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
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

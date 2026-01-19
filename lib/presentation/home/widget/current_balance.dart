import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/theme/money_colors.dart';
import 'package:moneyplus/design_system/theme/money_typography.dart';

class CurrentBalance extends StatefulWidget {
  const CurrentBalance({
    super.key,
    required this.balance,
    required this.percentage,
  });

  final String balance;
  final double percentage;

  @override
  State<StatefulWidget> createState() {
    return _CurrentBalanceState();
  }
}

class _CurrentBalanceState extends State<CurrentBalance> {
  var showBalance = true;

  @override
  Widget build(BuildContext context) {
    var balanceIcon = showBalance ? AppAssets.openEye : AppAssets.closedEye;
    var balance = showBalance ? widget.balance : _getHiddenBalance(widget.balance);
    var topPadding = showBalance ? 0.0 : 4.0;
    var percentageIcon = widget.percentage > 0 ? AppAssets.tradeUp : AppAssets.tradeDown;
    var percentageText = widget.percentage > 0 ? 'Saving' : 'Spending';
    var percentageColor = widget.percentage > 0 ? MoneyColors.light.green : MoneyColors.light.red;

    return SizedBox(
      height: 72,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Current Balance",
            style: MoneyTypography.typography.label.small.copyWith(
              color: MoneyColors.light.body,
            ),
          ),
          Row(
            children: [
              Text(
                balance,
                style: MoneyTypography.typography.headline.small.copyWith(
                  color: MoneyColors.light.title,
                ),
              ),
              SizedBox(width: 8),
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
            children: [
              SvgPicture.asset(percentageIcon, width: 16, height: 16),
              SizedBox(width: 4),
              Text(
                "${widget.percentage}% $percentageText",
                style: MoneyTypography.typography.label.xSmall?.copyWith(
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

String _getHiddenBalance(String balance){
  return List.filled(balance.length + 5, '•').join();
}

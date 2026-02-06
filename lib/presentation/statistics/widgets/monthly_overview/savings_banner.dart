import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';

class SavingsBanner extends StatelessWidget {
  final double savings;
  final String currency;

  const SavingsBanner({
    super.key,
    required this.savings,
    required this.currency,
  });

  String _formatNumber(double value) {
    final intValue = value.toInt();
    return intValue.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: colors.secondaryVariant, // #EAF3F4
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon - You can replace with your specific icon
          SvgPicture.asset(
            AppAssets.icWalletAdd, // Replace with your savings icon if different
            width: 14,
            height: 14,
            colorFilter: ColorFilter.mode(
              colors.secondary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 4),
          // Text - Label/XSmall, Secondary color
          Text(
            'You saved ${_formatNumber(savings)} $currency this month',
            style: typography.label.xSmall?.copyWith(
              color: colors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
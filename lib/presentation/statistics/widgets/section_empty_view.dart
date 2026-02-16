import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/constants/design_constants.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';

class SectionEmptyView extends StatelessWidget {
  final String title;
  final String message;

  const SectionEmptyView({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignConstants.spacingMedium),
      decoration: BoxDecoration(
        color: context.colors.surfaceLow,
        borderRadius: BorderRadius.circular(DesignConstants.radiusMedium),
      ),
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              title,
              style: context.typography.label.medium.copyWith(
                color: context.colors.title,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Image.asset(
            // todo : AppAssets.imgStatisticsEmpty,
            AppAssets.logo,
            width: 80,
            height: 80,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: context.typography.body.small.copyWith(
              color: context.colors.body,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
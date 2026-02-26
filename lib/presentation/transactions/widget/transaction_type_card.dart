import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/constants/design_constants.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:svg_flutter/svg.dart';

class TransactionTypeCard extends StatelessWidget {
  final String label;
  final String iconPath;
  final bool selected;
  final VoidCallback onTap;

  const TransactionTypeCard({
    super.key,
    required this.label,
    required this.iconPath,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    final Color borderColor = selected ? colors.primary : Colors.transparent;
    final Color backgroundColor = selected
        ? colors.primary.withValues(alpha: 0.08)
        : colors.surfaceLow;
    final Color contentColor = selected ? colors.primary : colors.body;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          vertical: DesignConstants.spacingMedium,
          horizontal: DesignConstants.spacingLarge,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(DesignConstants.radiusMedium),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              iconPath,
              width: DesignConstants.iconSizeMed,
              height: DesignConstants.iconSizeMed,
              colorFilter: ColorFilter.mode(contentColor, BlendMode.srcIn),
            ),
            const SizedBox(height: DesignConstants.spacingSmall),
            Text(
              label,
              style: typography.label.medium.copyWith(
                color: contentColor,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}

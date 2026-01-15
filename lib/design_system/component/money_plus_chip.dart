import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';

class MoneyPlusChip extends StatelessWidget {
  final bool isSelected;
  final String text;
  final String iconSvgPath;
  final VoidCallback onChipClicked;

  const MoneyPlusChip({
    super.key,
    required this.isSelected,
    required this.text,
    required this.iconSvgPath,
    required this.onChipClicked,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return GestureDetector(
      onTap: onChipClicked,
      child: Container(
        padding: EdgeInsetsGeometry.symmetric(vertical: 6, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.surfaceLow,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colors.primaryVariant.withOpacity(0.50),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                    blurStyle: BlurStyle.inner,
                  ),
                  BoxShadow(
                    color: colors.primary.withOpacity(0.16),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: typography.label.medium.copyWith(
                color: isSelected ? colors.onPrimary : colors.title,
              ),
            ),
            SizedBox(width: 8),
            SvgPicture.asset(
              iconSvgPath,
              color: isSelected ? colors.onPrimary : colors.title,
              width: 20,
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

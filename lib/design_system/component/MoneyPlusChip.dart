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
        padding: EdgeInsetsGeometry.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.surfaceLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: typography.label.medium.copyWith(
                color: isSelected ? colors.onPrimary : colors.primary,
              ),
            ),
            SizedBox(width: 8),
            SvgPicture.asset(
              iconSvgPath,
              color: isSelected ? colors.onPrimary : colors.primary,
              width: 20,
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

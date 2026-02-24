import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';

class SelectedCategoryItem extends StatelessWidget {
  final String label;
  final VoidCallback onDelete;

  const SelectedCategoryItem({
    super.key,
    required this.label,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typography;

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colors.surfaceLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              label,
              style: typo.body.medium.copyWith(color: colors.title),
            ),
          ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: onDelete,
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.redVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SvgPicture.asset(
              AppAssets.iconCancelCategory,
              width: 52,
              height: 28,
              colorFilter: ColorFilter.mode(colors.red, BlendMode.srcIn),
            ),
          ),
        ),
      ],
    );
  }
}
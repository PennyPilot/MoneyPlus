import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../design_system/assets/app_assets.dart';
import '../../../design_system/theme/money_extension_context.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final VoidCallback onEdit;

  const CategoryChip({super.key, required this.label, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: typography.label.medium),
          const SizedBox(width: 8),
          InkWell(onTap: onEdit, child: SvgPicture.asset(AppAssets.icEdit)),
        ],
      ),
    );
  }
}
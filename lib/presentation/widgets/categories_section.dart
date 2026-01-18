import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import '../../design_system/widgets/chip.dart';

class CategoriesSection extends StatelessWidget {
  final List<String> categories;
  final String? selected;
  final ValueChanged<String>? onSelect;
  final VoidCallback? onAdd;
  final Widget Function(String category, bool isSelected)? trailingBuilder;

  const CategoriesSection({
    super.key,
    required this.categories,
    this.selected,
    this.onSelect,
    this.onAdd,
    this.trailingBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...categories.map((category) {
          final isSelected = selected == category;
          return MChip(
            label: category,
            selected: isSelected,
            onTap: () => onSelect?.call(category),
            trailing: trailingBuilder?.call(category, isSelected),
          );
        }),
        if (onAdd != null)
          MChip(
            selected: false,
            onTap: onAdd!,
            trailing: SvgPicture.asset(AppAssets.icAdd),
          ),
      ],
    );
  }
}

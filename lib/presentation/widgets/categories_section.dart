import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/widgets/chip.dart';

enum SelectionMode { single, multi }

class CategoriesSection extends StatelessWidget {
  final List<String> categories;
  final Set<String> selected;
  final SelectionMode mode;
  final ValueChanged<Set<String>>? onChanged;
  final VoidCallback? onAdd;
  final Widget Function(String category, bool isSelected)? trailingBuilder;

  const CategoriesSection({
    super.key,
    required this.categories,
    this.selected = const {},
    this.mode = SelectionMode.single,
    this.onChanged,
    this.onAdd,
    this.trailingBuilder,
  });

  void _handleTap(String category) {
    if (onChanged == null) return;

    Set<String> newSelection;

    if (mode == SelectionMode.single) {
      newSelection = selected.contains(category) ? {} : {category};
    } else {
      newSelection = Set<String>.from(selected);
      if (newSelection.contains(category)) {
        newSelection.remove(category);
      } else {
        newSelection.add(category);
      }
    }

    onChanged!(newSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...categories.map((category) {
          final isSelected = selected.contains(category);
          return MChip(
            label: category,
            selected: isSelected,
            onTap: () => _handleTap(category),
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

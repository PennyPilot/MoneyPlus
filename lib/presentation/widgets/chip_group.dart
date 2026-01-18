import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/widgets/chip.dart';

enum SelectionMode { single, multi }
enum ChipGroupLayout { wrap, row, scrollableRow }

class ChipGroup extends StatelessWidget {
  final List<String> items;
  final Set<String> selected;
  final SelectionMode mode;
  final ChipGroupLayout layout;
  final ValueChanged<Set<String>>? onChanged;
  final VoidCallback? onAdd;
  final Widget Function(String item, bool isSelected)? trailingBuilder;
  final double spacing;
  final double runSpacing;

  const ChipGroup({
    super.key,
    required this.items,
    this.selected = const {},
    this.mode = SelectionMode.single,
    this.layout = ChipGroupLayout.wrap,
    this.onChanged,
    this.onAdd,
    this.trailingBuilder,
    this.spacing = 8,
    this.runSpacing = 8,
  });

  void _handleTap(String item) {
    if (onChanged == null) return;

    Set<String> newSelection;

    if (mode == SelectionMode.single) {
      newSelection = selected.contains(item) ? {} : {item};
    } else {
      newSelection = Set<String>.from(selected);
      if (newSelection.contains(item)) {
        newSelection.remove(item);
      } else {
        newSelection.add(item);
      }
    }

    onChanged!(newSelection);
  }

  @override
  Widget build(BuildContext context) {
    final chips = _buildChips();

    return switch (layout) {
      ChipGroupLayout.wrap => Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: chips,
      ),
      ChipGroupLayout.row => Row(
        mainAxisSize: MainAxisSize.min,
        children: _buildChipsWithSpacing(chips),
      ),
      ChipGroupLayout.scrollableRow => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _buildChipsWithSpacing(chips),
        ),
      ),
    };
  }

  List<Widget> _buildChips() {
    return [
      ...items.map((item) {
        final isSelected = selected.contains(item);
        return MChip(
          label: item,
          selected: isSelected,
          onTap: () => _handleTap(item),
          trailing: trailingBuilder?.call(item, isSelected),
        );
      }),
      if (onAdd != null)
        MChip(
          selected: false,
          onTap: onAdd!,
          trailing: SvgPicture.asset(AppAssets.icAdd),
        ),
    ];
  }

  List<Widget> _buildChipsWithSpacing(List<Widget> chips) {
    final result = <Widget>[];
    for (int i = 0; i < chips.length; i++) {
      result.add(chips[i]);
      if (i < chips.length - 1) {
        result.add(SizedBox(width: spacing));
      }
    }
    return result;
  }
}
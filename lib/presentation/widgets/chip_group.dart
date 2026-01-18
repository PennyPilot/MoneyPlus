import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import '../../design_system/widgets/chip.dart';

enum SelectionMode { single, multi }
enum ChipGroupLayout { wrap, row }

class ChipGroup extends StatelessWidget {
  final List<String> items;
  final Set<String> selected;
  final SelectionMode mode;
  final ChipGroupLayout layout;
  final ValueChanged<Set<String>>? onChanged;
  final VoidCallback? onAdd;
  final ValueChanged<String>? onEdit;
  final double horizontalSpacing;
  final double verticalSpacing;

  const ChipGroup({
    super.key,
    required this.items,
    this.selected = const {},
    this.mode = SelectionMode.single,
    this.layout = ChipGroupLayout.wrap,
    this.onChanged,
    this.onAdd,
    this.onEdit,
    this.horizontalSpacing = 8,
    this.verticalSpacing = 8,
  });

  void _handleTap(String item) {
    if (onEdit != null) {
      onEdit!(item);
      return;
    }

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
    final chips = _buildChips(context);

    return switch (layout) {
      ChipGroupLayout.wrap => Wrap(
        spacing: horizontalSpacing,
        runSpacing: verticalSpacing,
        children: chips,
      ),
      ChipGroupLayout.row => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: _buildChipsWithSpacing(chips)),
      ),
    };
  }

  List<Widget> _buildChips(BuildContext context) {
    return [
      ...items.map((item) {
        final isSelected = selected.contains(item);
        return MChip(
          label: item,
          selected: isSelected,
          onTap: () => _handleTap(item),
          trailing: onEdit != null ? SvgPicture.asset(AppAssets.icEdit) : null,
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
        result.add(SizedBox(width: horizontalSpacing));
      }
    }
    return result;
  }
}
import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/constants/design_constants.dart';
import 'package:moneyplus/design_system/widgets/bottom_sheet.dart';
import 'package:moneyplus/design_system/widgets/buttons/button/default_button.dart';
import 'package:moneyplus/design_system/widgets/buttons/secondary/defult_secondary_button.dart';
import 'package:moneyplus/design_system/widgets/chip.dart';
import 'package:moneyplus/utils/extenstions/show_bottom_sheet.dart';

import '../../../core/l10n/app_localizations.dart';

Future<List<String>?> showCategoriesFilterBottomSheet({
  required BuildContext context,
  required List<String> categories,
  Set<String>? initialSelectedCategories,
}) {
  return context.showBlurBottomSheet<List<String>>(
    CategoriesFilterBottomSheet(
      categories: categories,
      initialSelectedCategories: initialSelectedCategories,
    ),
  );
}

class CategoriesFilterBottomSheet extends StatefulWidget {
  final List<String> categories;
  final Set<String>? initialSelectedCategories;

  const CategoriesFilterBottomSheet({
    super.key,
    required this.categories,
    this.initialSelectedCategories,
  });

  @override
  State<CategoriesFilterBottomSheet> createState() =>
      _CategoriesFilterBottomSheetState();
}

class _CategoriesFilterBottomSheetState extends State<CategoriesFilterBottomSheet> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set<String>.from(widget.initialSelectedCategories ?? const {});
  }

  void _toggle(String category) {
    setState(() {
      if (_selected.contains(category)) {
        _selected.remove(category);
      } else {
        _selected.add(category);
      }
    });
  }

  void _clear() {
    setState(() {
      _selected.clear();
    });
  }

  void _apply() {
    final selectedInOrder = widget.categories
        .where(_selected.contains)
        .toList(growable: false);
    Navigator.of(context).pop(selectedInOrder);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return MBottomSheet(
      title: l10n.categoriesFilterTitle,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: DesignConstants.spacingSmall,
            runSpacing: DesignConstants.spacingSmall,
            children: [
              for (final category in widget.categories)
                MChip(
                  label: category,
                  selected: _selected.contains(category),
                  onTap: () => _toggle(category),
                ),
            ],
          ),
        ],
      ),
      actionButtons: [
        DefaultSecondaryButton(
          text: l10n.categoriesFilterClear,
          isEnabled: _selected.isNotEmpty,
          onPressed: _selected.isNotEmpty ? _clear : null,
        ),
        DefaultButton(
          text: l10n.categoriesFilterApply,
          onPressed: _apply,
        ),
      ],
    );
  }
}


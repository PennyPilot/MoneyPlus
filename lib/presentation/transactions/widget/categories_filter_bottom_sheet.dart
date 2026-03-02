import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/constants/design_constants.dart';
import 'package:moneyplus/design_system/widgets/bottom_sheet.dart';
import 'package:moneyplus/design_system/widgets/buttons/button/default_button.dart';
import 'package:moneyplus/design_system/widgets/buttons/secondary/defult_secondary_button.dart';
import 'package:moneyplus/design_system/widgets/chip.dart';
import 'package:moneyplus/domain/entity/transaction_category.dart';
import 'package:moneyplus/utils/extenstions/show_bottom_sheet.dart';

import '../../../core/l10n/app_localizations.dart';

Future<List<int>?> showCategoriesFilterBottomSheet({
  required BuildContext context,
  required List<TransactionCategory> categories,
  required Function(List<int>) onCategoriesSelected,
  Set<int>? initialSelectedCategories,
}) {
  return context.showBlurBottomSheet<List<int>>(
    CategoriesFilterBottomSheet(
      categories: categories,
      initialSelectedCategories: initialSelectedCategories,
      onCategoriesSelected: onCategoriesSelected,
    ),
  );
}

class CategoriesFilterBottomSheet extends StatefulWidget {
  final List<TransactionCategory> categories;
  final Set<int>? initialSelectedCategories;
  final Function(List<int>) onCategoriesSelected;

  const CategoriesFilterBottomSheet({
    super.key,
    required this.categories,
    this.initialSelectedCategories,
    required this.onCategoriesSelected,
  });

  @override
  State<CategoriesFilterBottomSheet> createState() =>
      _CategoriesFilterBottomSheetState();
}

class _CategoriesFilterBottomSheetState extends State<CategoriesFilterBottomSheet> {
  late Set<int> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set<int>.from(widget.initialSelectedCategories ?? const {});
  }

  void _toggle(int categoryId) {
    setState(() {
      if (_selected.contains(categoryId)) {
        _selected.remove(categoryId);
      } else {
        _selected.add(categoryId);
      }
    });
  }

  void _clear() {
    setState(() {
      _selected.clear();
    });
    widget.onCategoriesSelected(const []);
  }

  void _apply() {
    Navigator.of(context).pop(_selected.toList());
    widget.onCategoriesSelected(_selected.toList());
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
                  label: category.name,
                  selected: _selected.contains(category.id),
                  onTap: () => _toggle(category.id),
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


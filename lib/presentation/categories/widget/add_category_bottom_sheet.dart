import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/widgets/text_field.dart';
import 'package:svg_flutter/svg.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../design_system/theme/money_extension_context.dart';
import '../../../design_system/widgets/buttons/button/default_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/categories_cubit.dart';
import '../../../domain/entity/category.dart';

class AddCategorySheet extends StatefulWidget {
  final Category? category;
  const AddCategorySheet({super.key, this.category});

  @override
  State<AddCategorySheet> createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends State<AddCategorySheet> {
  String _categoryName = '';
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _categoryName = _getInitialName();
    _isButtonEnabled = _categoryName.trim().isNotEmpty;
  }

  String _getInitialName() {
    if (widget.category == null) return '';
    return _categoryNameByLocale(widget.category!);
  }

  String _categoryNameByLocale(Category category) {
    final isArabic = Intl.getCurrentLocale() == 'ar';
    return (isArabic && category.nameAr.trim().isNotEmpty)
        ? category.nameAr
        : category.name;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final localizations = AppLocalizations.of(context)!;
    final isEdit = widget.category != null;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(localizations, isEdit),
              Divider(color: colors.stroke, thickness: 1),
              const SizedBox(height: 12),
              MTextField(
                leading: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 16, end: 8),
                  child: SvgPicture.asset(AppAssets.icCategory),
                ),
                hint: localizations.category_name,
                value: _categoryName,
                onChanged: (String value) {
                  setState(() {
                    _categoryName = value;
                    _isButtonEnabled = _categoryName.trim().isNotEmpty;
                  });
                },
              ),
              const SizedBox(height: 24),
              DefaultButton(
                text: isEdit ? localizations.edit : localizations.add,
                isEnabled: _isButtonEnabled,
                onPressed: _isButtonEnabled ? () => _submit(context) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n, bool isEdit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          isEdit ? l10n.edit : l10n.add_custom_category,
          style: context.typography.title.small,
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset(AppAssets.iconCancel),
        ),
      ],
    );
  }

  void _submit(BuildContext context) {
    final cubit = context.read<CategoriesCubit>();
    final trimmedName = _categoryName.trim();
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    if (widget.category != null) {
      final updated = isArabic
          ? widget.category!.copyWith(nameAr: trimmedName)
          : widget.category!.copyWith(name: trimmedName);
      cubit.updateCategory(updated);
    } else {
      cubit.addCategory(trimmedName);
    }

    Navigator.pop(context);
  }
}

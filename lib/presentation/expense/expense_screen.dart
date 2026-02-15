
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/app_bar.dart';
import 'package:moneyplus/design_system/widgets/text_field.dart';
import 'package:moneyplus/design_system/widgets/text_field_date_Picker.dart';

import '../../core/l10n/app_localizations.dart';
import '../../design_system/widgets/buttons/money_button.dart';
import '../../design_system/widgets/chip.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  String _amount = '';
  String _selectedCategory = 'Food';
  String _note = '';

  final List<String> _categories = [
    'Food',
    'Transport',
    'Rent',
    'Entertainment',
    'Electricity',
    'Shopping',
    'Health',
    'Fitness / Gym',
    'Internet',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
        title: l10n.makeAnExpense,
        leading: AppBarCircleButton(
          assetPath: AppAssets.icArrowLeft,
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildAmountSection(context),
                  _buildDateSection(context),
                  _buildCategorySection(context),
                  _buildNoteSection(context),
                ],
              ),
            ),
            _buildSaveButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountSection(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: MTextField(
        hint: l10n.amount,
        value: _amount,
        keyboardType: TextInputType.number,
        leading: Padding(
          padding: const EdgeInsetsGeometry.directional(end: 8),
          child: SvgPicture.asset(
            AppAssets.icAmountGray,
            width: 24,
            height: 24,
          ),
        ),
        trailing: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'IQD',
                style: typography.label.small.copyWith(color: colors.body),
              ),
            ],
          ),
        ),
        onChanged: (value) => setState(() => _amount = value),
      ),
    );
  }

  Widget _buildDateSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFieldDatePicker(
        hint: l10n.date,
        onError: () {},
        onDateChange: (date) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            l10n.categories,
            style: typography.title.small.copyWith(color: colors.title),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 12,
            children: [
              ..._categories.map((category) {
                return MChip(
                  label: category,
                  selected: _selectedCategory == category,
                  onTap: () {
                    setState(() => _selectedCategory = category);
                  },
                );
              }),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  width: 44,
                  height: 32,
                  decoration: BoxDecoration(
                    color: colors.surfaceLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.add, color: colors.title, size: 24),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoteSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: MTextField(
        hint: l10n.note,
        value: _note,
        minLines: 4,
        maxLines: 6,
        onChanged: (value) => setState(() => _note = value),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: MoneyButton(
        text: l10n.save,
        backgroundColor: colors.primary,
        disabledBackgroundColor: colors.disabled,
        textColor: colors.onPrimary,
        disabledTextColor: colors.onPrimary,
        onPressed: () {},
      ),
    );
  }
}

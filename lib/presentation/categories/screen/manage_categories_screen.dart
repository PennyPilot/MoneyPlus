import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../design_system/theme/money_extension_context.dart';
import '../../../design_system/widgets/buttons/button/default_button.dart';
import '../widget/add_category_bottom_sheet.dart';
import '../widget/category_chip.dart';

class ManageCategoriesScreen extends StatelessWidget {
  ManageCategoriesScreen({super.key});

  // TODO : Replace with actual categories from backend
  final List<String> categories = [
    'Food',
    'Transport',
    'Rent',
    'Entertainment',
    'Electricity',
    'Shopping',
    'Health',
    'Fitness / Gym',
    'Internet',
    'Cats',
    'University',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsetsGeometry.only(left: 16),
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => context.pop(),
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.surface,
                shape: BoxShape.circle,
              ),
              child: Center(child: SvgPicture.asset(AppAssets.icArrowLeft)),
            ),
          ),
        ),
        title: Text(localizations.manage_categories, style: typography.title.small),
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.only(top: 16, left: 16, right: 16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories
              .map(
                (category) => CategoryChip(
                  label: category,
                  onEdit: () => print('$category'),
                ),
              )
              .toList(),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 84,
        color: colors.surfaceLow,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: DefaultButton(
            text: localizations.add_new_category,
            onPressed: () => _openBottomSheet(context),
          ),
        ),
      ),
    );
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddCategorySheet(),
    );
  }
}

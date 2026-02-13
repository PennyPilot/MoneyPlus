import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/design_system/widgets/chip.dart';
import 'package:moneyplus/design_system/widgets/text_field.dart';
import 'package:moneyplus/presentation/account_setup/cubit/account_setup_cubit.dart';
import 'package:moneyplus/presentation/account_setup/cubit/account_setup_state.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../design_system/theme/money_extension_context.dart';
import '../../../design_system/widgets/selected_category_item.dart';

class Page3 extends StatefulWidget {
  final AccountSetupState state;
  const Page3({super.key, required this.state});

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  final TextEditingController categoryController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    categoryController.addListener(() {
      setState(() {
        _searchQuery = categoryController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<AccountSetupCubit>();

    final filteredSuggestions = widget.state.suggestions
        .where((suggestion) =>
            suggestion.toLowerCase().contains(_searchQuery) &&
            !widget.state.categories.contains(suggestion))
        .toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Where do you usually spend your money?',
            style: context.typography.label.small.copyWith(
              color: context.colors.body,
            ),
          ),
          const SizedBox(height: 24),
          MTextField(
            hint: 'Category name',
            keyboardType: TextInputType.text,
            value: categoryController.text,
            onChanged: (value) {
              categoryController.text = value;
            },
          ),
          const SizedBox(height: 16),
          if (filteredSuggestions.isNotEmpty) ...[
            Text(
              'Suggestions:',
              style: context.typography.label.medium.copyWith(
                color: context.colors.title,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: filteredSuggestions.map((suggestion) {
                return MChip(
                  label: suggestion,
                  selected: false,
                  onTap: () {
                    cubit.toggleCategory(suggestion);
                    categoryController.clear();
                  },
                );
              }).toList(),
            ),
          ],
          if (widget.state.categories.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Selected Categories:',
              style: context.typography.label.medium.copyWith(
                color: context.colors.title,
              ),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.state.categories.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final category = widget.state.categories[index];
                return SelectedCategoryItem(
                  label: category,
                  onDelete: () => cubit.toggleCategory(category),
                );
              },
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/design_system/widgets/chip.dart';
import 'package:moneyplus/design_system/widgets/text_field.dart';
import 'package:moneyplus/presentation/account_setup/cubit/account_setup_cubit.dart';
import 'package:moneyplus/presentation/account_setup/cubit/account_setup_state.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../design_system/theme/money_extension_context.dart';
import '../../../design_system/widgets/selected_category_item.dart';

class Page2 extends StatefulWidget {
  final AccountSetupState state;
  const Page2({super.key, required this.state});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final TextEditingController categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<AccountSetupCubit>();

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
            children: widget.state.suggestions.map((suggestion) {
              final isSelected = widget.state.categories.contains(suggestion);
              if (isSelected) {
                return const SizedBox.shrink();
              }
              return MChip(
                label: suggestion,
                selected: false,
                onTap: () => cubit.toggleCategory(suggestion),
              );
            }).toList(),
          ),

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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/app_bar.dart';
import 'package:moneyplus/design_system/widgets/text_field.dart';
import 'package:moneyplus/design_system/widgets/text_field_date_Picker.dart';
import 'package:moneyplus/presentation/expense/edit/cubit/edit_expense_cubit.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../design_system/widgets/buttons/button/default_button.dart';
import '../../../../design_system/widgets/chip.dart';
import '../../../../design_system/widgets/snack_bar.dart';
import '../../../../domain/model/form_status.dart';
import '../cubit/edit_expense_state.dart';

class EditExpenseScreen extends StatelessWidget {
  final String transactionId;

  const EditExpenseScreen({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EditExpenseCubit>(param1: transactionId),
      child: const _EditExpenseScreenContent(),
    );
  }
}

class _EditExpenseScreenContent extends StatelessWidget {
  const _EditExpenseScreenContent();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: CustomAppBar(
        title: localization.editExpense,
        backgroundColor: colors.surfaceLow,
        leading: AppBarCircleButton(
          assetPath: AppAssets.icArrowLeft,
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<EditExpenseCubit, EditExpenseState>(
        listener: (context, state) {
          final localization = AppLocalizations.of(context)!;

          if (state.status == FormStatus.success) {
            MSnackBar.success(
              message: localization.expenseUpdatedSuccessfully,
              title: '',
            ).showSnackBar(context: context);
            Navigator.pop(context);
          } else if (state.status == FormStatus.failure) {
            MSnackBar.error(
              message: state.errorMessage ?? localization.failedToUpdateExpense,
              title: '',
            ).showSnackBar(context: context);
          }
        },
        builder: (context, state) {
          if (state.isLoadingTransaction) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildAmountSection(context, state),
                      _buildDateSection(context, state),
                      _buildCategorySection(context, state),
                      _buildNoteSection(context, state),
                    ],
                  ),
                ),
                _buildSaveButton(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAmountSection(BuildContext context, EditExpenseState state) {
    final colors = context.colors;
    final typography = context.typography;
    final localization = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: MTextField(
        hint: localization.amount,
        value: state.amount != null ? state.amount!.toStringAsFixed(0) : '',
        keyboardType: TextInputType.number,
        leading: Padding(
          padding: const EdgeInsetsDirectional.only(end: 8),
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
                state.currency?.abbreviation ?? "",
                style: typography.label.small.copyWith(color: colors.body),
              ),
            ],
          ),
        ),
        onChanged: (value) {
          context.read<EditExpenseCubit>().onAmountChanged(value);
        },
      ),
    );
  }

  Widget _buildDateSection(BuildContext context, EditExpenseState state) {
    final localization = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFieldDatePicker(
        hint: localization.date,
        onError: () {},
        onDateChange: (date) {
          context.read<EditExpenseCubit>().onDateChanged(date);
        },
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, EditExpenseState state) {
    final colors = context.colors;
    final typography = context.typography;
    final localization = AppLocalizations.of(context)!;

    if (state.isLoadingCategories && state.categories.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            localization.categories,
            style: typography.title.small.copyWith(color: colors.title),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 12,
            children: [
              ...state.categories.map((category) {
                final selected = state.selectedCategory?.id == category.id;
                return MChip(
                  label: category.name,
                  selected: selected,
                  onTap: () {
                    context.read<EditExpenseCubit>().onCategorySelected(
                      category,
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoteSection(BuildContext context, EditExpenseState state) {
    final localization = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: MTextField(
        hint: localization.note,
        value: state.note,
        minLines: 4,
        maxLines: 6,
        onChanged: (value) {
          context.read<EditExpenseCubit>().onNoteChanged(value);
        },
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, EditExpenseState state) {
    final localization = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 19),
      child: DefaultButton(
        text: state.status == FormStatus.loading
            ? localization.saving
            : localization.save,
        onPressed: () {
          context.read<EditExpenseCubit>().onSubmitExpense();
        },
        isEnabled: state.canSubmitForm,
      ),
    );
  }
}

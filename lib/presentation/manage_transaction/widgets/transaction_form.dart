import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/core/l10n/app_localizations.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/chip.dart';
import 'package:moneyplus/design_system/widgets/text_field.dart';
import 'package:moneyplus/design_system/widgets/text_field_date_Picker.dart';
import 'package:moneyplus/design_system/widgets/app_loading_indicator.dart';
import 'package:moneyplus/domain/entity/currency.dart';
import 'package:moneyplus/domain/entity/transaction_category.dart';
import 'package:moneyplus/presentation/account_setup/widget/currency_bottom_sheet.dart';
import 'package:moneyplus/presentation/manage_transaction/cubit/manage_transaction_cubit.dart';
import 'package:moneyplus/presentation/manage_transaction/cubit/manage_transaction_state.dart';

class TransactionForm extends StatelessWidget {
  final ManageTransactionState state;
  final Function(String) onAmountChanged;
  final Function(DateTime) onDateChanged;
  final Function(TransactionCategory) onCategorySelected;
  final Function(String) onNoteChanged;
  final Function(Currency)? onCurrencySelected;

  const TransactionForm({
    super.key,
    required this.state,
    required this.onAmountChanged,
    required this.onDateChanged,
    required this.onCategorySelected,
    required this.onNoteChanged,
    this.onCurrencySelected,
  });

  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 120), // Added 120px bottom padding
      children: [
        _buildAmountSection(context),
        _buildDateSection(context),
        _buildCategorySection(context),
        _buildNoteSection(context),
      ],
    );
  }

  Widget _buildAmountSection(BuildContext context) {
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
        trailing: onCurrencySelected != null
            ? GestureDetector(
                onTap: () => _openCurrencyBottomSheet(context),
                child: state.currency != null && state.currency!.abbreviation.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.currency!.abbreviation,
                              style: typography.label.small.copyWith(color: colors.body),
                            ),
                            const SizedBox(width: 4),
                            SvgPicture.asset(
                              AppAssets.icArrowDownRound,
                              height: 12,
                              width: 12,
                              colorFilter: ColorFilter.mode(
                                context.colors.body,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsetsDirectional.only(
                          top: 14,
                          bottom: 14,
                          end: 8,
                        ),
                        child: SvgPicture.asset(
                          AppAssets.icArrowDownRound,
                          height: 20,
                          width: 20,
                          colorFilter: ColorFilter.mode(
                            context.colors.body,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
              )
            : state.currency != null && state.currency!.abbreviation.isNotEmpty
                ? Container(
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
                          state.currency!.abbreviation,
                          style: typography.label.small.copyWith(color: colors.body),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
        onChanged: onAmountChanged,
      ),
    );
  }

  Future<void> _openCurrencyBottomSheet(BuildContext context) async {
    final cubit = context.read<ManageTransactionCubit>();

    final result = await showModalBottomSheet<Currency>(
      context: context,
      useRootNavigator: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: context.colors.surface,
      useSafeArea: true,
      builder: (_) {
        return BlocBuilder<ManageTransactionCubit, ManageTransactionState>(
          bloc: cubit,
          builder: (context, state) {
            return CurrencyBottomSheet(
              currencies: state.filteredCurrencies,
              isLoading: state.isLoadingCurrencies,
              query: state.currencyQuery,
              onSearchChanged: (value) {
                cubit.onCurrencySearchChanged(value);
              },
            );
          },
        );
      },
    );

    if (result != null) {
      onCurrencySelected?.call(result);
    }
  }

  Widget _buildDateSection(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFieldDatePicker(
        hint: localization.date,
        initialDate: state.date,
        onError: () {},
        onDateChange: onDateChanged,
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final localization = AppLocalizations.of(context)!;

    if (state.isLoadingCategories && state.categories.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 16),
        child: AppLoadingIndicator(),
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
                  onTap: () => onCategorySelected(category),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoteSection(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: MTextField(
        hint: localization.note,
        value: state.note,
        minLines: 4,
        maxLines: 6,
        onChanged: onNoteChanged,
      ),
    );
  }
}

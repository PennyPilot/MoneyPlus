import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moneyplus/core/di/injection.dart';
import 'package:moneyplus/core/l10n/app_localizations.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/app_bar.dart';
import 'package:moneyplus/design_system/widgets/buttons/button/default_button.dart';
import 'package:moneyplus/design_system/widgets/snack_bar.dart';
import 'package:moneyplus/domain/entity/transaction_type.dart';
import 'package:moneyplus/domain/model/form_status.dart';
import 'package:moneyplus/presentation/manage_transaction/cubit/manage_transaction_cubit.dart';
import 'package:moneyplus/presentation/manage_transaction/cubit/manage_transaction_state.dart';
import 'package:moneyplus/presentation/manage_transaction/widgets/transaction_form.dart';

class AddTransactionScreen extends StatelessWidget {
  final TransactionType transactionType;

  const AddTransactionScreen({
    super.key,
    required this.transactionType,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ManageTransactionCubit>(
        param1: transactionType,
      ),
      child: const _AddTransactionScreenContent(),
    );
  }
}

class _AddTransactionScreenContent extends StatelessWidget {
  const _AddTransactionScreenContent();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final localization = AppLocalizations.of(context)!;

    return BlocConsumer<ManageTransactionCubit, ManageTransactionState>(
      listener: (context, state) {
        if (state.status == FormStatus.success) {
          MSnackBar.success(
            message: state.transactionType == TransactionType.income
                ? localization.incomeAddedSuccessfully
                : localization.expenseAddedSuccessfully,
            title: '',
          ).showSnackBar(context: context);
          Navigator.pop(context);
        } else if (state.status == FormStatus.failure) {
          MSnackBar.error(
            message: state.errorMessage ?? localization.failedToAddTransaction,
            title: '',
          ).showSnackBar(context: context);
        }
      },
      builder: (context, state) {
        final title = state.transactionType == TransactionType.income
            ? localization.addIncome
            : localization.addAnExpense;

        return Scaffold(
          backgroundColor: colors.surface,
          appBar: CustomAppBar(
            title: title,
            backgroundColor: colors.surfaceLow,
            leading: AppBarCircleButton(
              assetPath: AppAssets.icArrowLeft,
              onTap: () => context.pop(),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: TransactionForm(
                    state: state,
                    onAmountChanged: (val) => context.read<ManageTransactionCubit>().onAmountChanged(val),
                    onDateChanged: (val) => context.read<ManageTransactionCubit>().onDateChanged(val),
                    onCategorySelected: (val) => context.read<ManageTransactionCubit>().onCategorySelected(val),
                    onNoteChanged: (val) => context.read<ManageTransactionCubit>().onNoteChanged(val),
                    onCurrencySelected: (val) => context.read<ManageTransactionCubit>().onCurrencyChanged(val),
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 19),
                  child: DefaultButton(
                    text: state.status == FormStatus.loading ? localization.saving : localization.add,
                    onPressed: () => context.read<ManageTransactionCubit>().submit(),
                    isEnabled: state.canSubmitForm,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

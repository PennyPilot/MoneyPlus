import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/core/l10n/app_localizations.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/snack_bar.dart';
import 'package:moneyplus/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:moneyplus/presentation/transactions/cubit/transaction_state.dart';
import 'package:moneyplus/presentation/transactions/widget/empty_transactions.dart';
import 'package:moneyplus/presentation/transactions/widget/categories_filter_bottom_sheet.dart';
import 'package:moneyplus/presentation/transactions/widget/loading_view.dart';
import 'package:moneyplus/presentation/transactions/widget/tabs_row.dart';
import 'package:moneyplus/presentation/transactions/widget/transaction_app_bar.dart';
import 'package:moneyplus/presentation/transactions/widget/transactions_list.dart';
import '../../../core/di/injection.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: colors.surface,
      body: BlocProvider(
        create: (_) => getIt<TransactionCubit>()..loadData(),
        child: BlocConsumer<TransactionCubit, TransactionState>(
          listener: (context, state) {
            if (state.status == TransactionStatus.failure) {
              MSnackBar.error(
                message: localizations.transaction_error_content,
                title: localizations.transaction_error_title,
              ).showSnackBar(context: context);
            }
          },
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: TransactionAppBar(
                    year: state.selectedYear,
                    month: state.selectedMonth,
                    onDatePick: context.read<TransactionCubit>().setSelectedDate,
                    onFilterClicked: () async {
                      final result = await showCategoriesFilterBottomSheet(
                        context: context,
                        categories: state.availableCategories,
                        initialSelectedCategories: state.selectedCategories,
                      );
                      if (result == null) return;
                      context
                          .read<TransactionCubit>()
                          .setSelectedCategories(result.toSet());
                    },
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 16, left: 16, top: 16),
                  sliver: SliverToBoxAdapter(
                    child: TabsRow(
                      selectedTab: state.selectedTab,
                      onTabSelected: context
                          .read<TransactionCubit>()
                          .onTabSelected,
                    ),
                  ),
                ),
                state.status == TransactionStatus.loading
                    ? SliverFillRemaining(child: LoadingView())
                    : state.filteredTransactions.isEmpty
                    ? SliverFillRemaining(child: EmptyTransactions())
                    : TransactionsList(transactions: state.filteredTransactions),
              ],
            );
          },
        ),
      ),
    );
  }
}

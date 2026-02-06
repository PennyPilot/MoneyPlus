import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/core/l10n/app_localizations.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/app_bar.dart';
import 'package:moneyplus/design_system/widgets/chip.dart';
import 'package:moneyplus/di/injection.dart';
import 'package:moneyplus/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:moneyplus/presentation/transactions/cubit/transaction_state.dart';
import 'package:moneyplus/presentation/transactions/widget/empty_transactions.dart';
import 'package:moneyplus/presentation/transactions/widget/transactions_list.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: colors.surface,
      body: BlocProvider(
        create: (_) => getIt<TransactionCubit>()..loadData(),
        child: BlocBuilder<TransactionCubit, TransactionState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: CustomAppBar(
                    title: "Transaction",
                    backgroundColor: colors.surfaceLow,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 16, left: 16, top: 16),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        MChip(
                          label: "All",
                          selected: state.selectedTab == TransactionTabs.all,
                          onTap: () {
                            context.read<TransactionCubit>().onTabSelected(
                              TransactionTabs.all,
                            );
                          },
                        ),
                        SizedBox(width: 12),
                        MChip(
                          label: "Incomes",
                          selected:
                              state.selectedTab == TransactionTabs.incomes,
                          onTap: () {
                            context.read<TransactionCubit>().onTabSelected(
                              TransactionTabs.incomes,
                            );
                          },
                        ),
                        SizedBox(width: 12),
                        MChip(
                          label: "Expenses",
                          selected:
                              state.selectedTab == TransactionTabs.expenses,
                          onTap: () {
                            context.read<TransactionCubit>().onTabSelected(
                              TransactionTabs.expenses,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                state.transactions.isEmpty
                    ? SliverToBoxAdapter(child: EmptyTransactions())
                    : TransactionsList(transactions: state.transactions),
              ],
            );
          },
        ),
      ),
    );
  }
}
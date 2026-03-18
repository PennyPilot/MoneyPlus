import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/core/l10n/app_localizations.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/snack_bar.dart';
import 'package:moneyplus/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:moneyplus/presentation/transactions/cubit/transaction_state.dart';
import 'package:moneyplus/presentation/transactions/widget/categories_filter_bottom_sheet.dart';
import 'package:moneyplus/presentation/transactions/widget/empty_transactions.dart';
import 'package:moneyplus/presentation/transactions/widget/loading_view.dart';
import 'package:moneyplus/presentation/transactions/widget/tabs_row.dart';
import 'package:moneyplus/presentation/transactions/widget/transaction_app_bar.dart';
import 'package:moneyplus/presentation/transactions/widget/transactions_list.dart';

class TransactionScreenContent extends StatefulWidget {
  const TransactionScreenContent({super.key});

  @override
  State<TransactionScreenContent> createState() =>
      _TransactionsScreenContentState();
}

class _TransactionsScreenContentState extends State<TransactionScreenContent> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 200) {
        context.read<TransactionCubit>().loadMore();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: colors.surface,
      body: BlocConsumer<TransactionCubit, TransactionState>(
        listener: (context, state) {
          if (state.status == TransactionStatus.failure) {
            MSnackBar.error(
              message: localizations.transaction_error_content,
              title: localizations.transaction_error_title,
            ).showSnackBar(context: context);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              TransactionAppBar(
                year: state.selectedYear,
                month: state.selectedMonth,
                onDatePick: context.read<TransactionCubit>().setSelectedDate,
                onFilterClicked: () {
                  showCategoriesFilterBottomSheet(
                    context: context,
                    categories: state.transactionCategories,
                    onCategoriesSelected:  context.read<TransactionCubit>().onCategoriesSelected,
                    initialSelectedCategories: state.selectedCategories.toSet()
                  );
                },
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 16, left: 16, top: 16),
                child: TabsRow(
                  selectedTab: state.selectedTab,
                  onTabSelected: context.read<TransactionCubit>().onTabSelected,
                ),
              ),

              Expanded(
                child: CustomScrollView(
                  controller: _controller,
                  slivers: [
                    state.status == TransactionStatus.loading
                        ? SliverFillRemaining(child: LoadingView())
                        : state.transactions.isEmpty
                        ? SliverFillRemaining(child: EmptyTransactions())
                        : TransactionsList(transactions: state.transactions),

                    if (state.isLoadingMore)
                      const SliverToBoxAdapter(child: LoadingView()),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/domain/entity/transaction.dart';
import 'package:moneyplus/domain/entity/transaction_type.dart';
import 'package:moneyplus/domain/repository/transaction_repository.dart';
import 'package:moneyplus/presentation/transactions/cubit/transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionRepository transactionRepository;

  TransactionCubit({required this.transactionRepository})
    : super(TransactionState.initial());

  void loadData() async {
    emit(state.copyWith(status: TransactionStatus.loading));

    final result = await transactionRepository.getAllTransactions();
    final now = DateTime.now();
    emit(
      state.copyWith(
        allTransactions: result,
        filteredTransactions: _filterTransaction(
          Month.values[now.month - 1],
          now.year,
          result,
        ),
        selectedYear: now.year,
        selectedMonth: Month.values[now.month - 1],
        status: TransactionStatus.success,
      ),
    );
  }

  void onTabSelected(TransactionTabs tab) async {
    if (state.selectedTab == tab) return;

    emit(state.copyWith(status: TransactionStatus.loading, selectedTab: tab));

    final result = await _getTransactionsByTab(tab);

    emit(
      state.copyWith(
        status: TransactionStatus.success,
        allTransactions: result,
        filteredTransactions: _filterTransaction(
          state.selectedMonth,
          state.selectedYear,
          result,
        ),
      ),
    );
  }

  void setSelectedDate(Month month, int year) async {
    if (state.selectedMonth == month && state.selectedYear == year) return;

    emit(
      state.copyWith(
        selectedMonth: month,
        selectedYear: year,
        status: TransactionStatus.loading,
      ),
    );

    emit(
      state.copyWith(
        status: TransactionStatus.success,
        filteredTransactions: _filterTransaction(month, year, state.allTransactions),
      ),
    );
  }

  Future<List<Transaction>> _getTransactionsByTab(TransactionTabs tab) async {
    return await switch (tab) {
      TransactionTabs.all => transactionRepository.getAllTransactions(),
      TransactionTabs.incomes => transactionRepository.getAllTransactionsByType(
        TransactionType.income,
      ),
      TransactionTabs.expenses =>
        transactionRepository.getAllTransactionsByType(TransactionType.expense),
    };
  }

  List<Transaction> _filterTransaction(
    Month month,
    int year,
    List<Transaction> transactions,
  ) {
    return transactions.where((transaction) {
      return transaction.date.year == year &&
          transaction.date.month == month.index + 1;
    }).toList();
  }
}

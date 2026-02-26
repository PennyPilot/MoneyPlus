import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:moneyplus/domain/entity/transaction.dart';
import 'package:moneyplus/domain/entity/transaction_type.dart';
import 'package:moneyplus/domain/repository/transaction_repository.dart';
import 'package:moneyplus/presentation/transactions/cubit/transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionRepository transactionRepository;

  TransactionCubit({required this.transactionRepository})
    : super(TransactionState.initial());

  static const List<String> _mockCategories = <String>[
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Health',
    'Entertainment',
    'Salary',
    'Gifts',
  ];

  void loadData() async {
    emit(state.copyWith(status: TransactionStatus.loading));

    final result = await transactionRepository.getAllTransactions();
    final now = DateTime.now();
    emit(
      state.copyWith(
        allTransactions: result,
        availableCategories: _mockCategories,
        filteredTransactions: _filterTransaction(
          month: now.month,
          year: now.year,
          transactions: result,
          selectedCategories: state.selectedCategories,
        ),
        selectedYear: now.year,
        selectedMonth: now.month,
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
          month: state.selectedMonth,
          year: state.selectedYear,
          transactions: result,
          selectedCategories: state.selectedCategories,
        ),
      ),
    );
  }

  void setSelectedDate(int month, int year) async {
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
        filteredTransactions: _filterTransaction(
          month: month,
          year: year,
          transactions: state.allTransactions,
          selectedCategories: state.selectedCategories,
        ),
      ),
    );
  }

  void setSelectedCategories(Set<String> categories) {
    if (setEquals(state.selectedCategories, categories)) return;

    emit(
      state.copyWith(
        selectedCategories: Set<String>.from(categories),
        filteredTransactions: _filterTransaction(
          month: state.selectedMonth,
          year: state.selectedYear,
          transactions: state.allTransactions,
          selectedCategories: categories,
        ),
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
    {
    required int month,
    required int year,
    required List<Transaction> transactions,
    required Set<String> selectedCategories,
  }
  ) {
    return transactions.where((transaction) {
      final matchesDate =
          transaction.date.year == year && transaction.date.month == month;
      if (!matchesDate) return false;

      if (selectedCategories.isEmpty) return true;
      return selectedCategories.contains(transaction.category.name);
    }).toList();
  }
}

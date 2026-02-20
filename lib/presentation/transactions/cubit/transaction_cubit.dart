import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/domain/entity/transaction_type.dart';
import 'package:moneyplus/domain/repository/transaction_repository.dart';
import 'package:moneyplus/presentation/transactions/cubit/transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionRepository transactionRepository;

  TransactionCubit({required this.transactionRepository})
    : super(TransactionState.initial());

  void loadData() async {
    emit(state.copyWith(status: TransactionStatus.loading));

    final now = DateTime.now();
    final result = await transactionRepository.getTransactions(page: 1, date: now);
    emit(
      state.copyWith(
        transactions: result,
        selectedYear: now.year,
        selectedMonth: now.month,
        status: TransactionStatus.success,
      ),
    );
  }

  void onTabSelected(TransactionTabs tab) async {
    if (state.selectedTab == tab) return;

    emit(state.copyWith(status: TransactionStatus.loading, selectedTab: tab));

    final result = await transactionRepository.getTransactions(
      page: 1,
      type: tab == TransactionTabs.expenses
          ? TransactionType.expense
          : tab == TransactionTabs.incomes
          ? TransactionType.income
          : null,
        date: DateTime(state.selectedYear, state.selectedMonth)
    );

    emit(
      state.copyWith(
        status: TransactionStatus.success,
        transactions: result,
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

    final result = await transactionRepository.getTransactions(
      page: 1,
      type: state.selectedTab == TransactionTabs.expenses
          ? TransactionType.expense
          : state.selectedTab == TransactionTabs.incomes
          ? TransactionType.income
          : null,
      date: DateTime(year, month)
    );

    emit(
      state.copyWith(
        status: TransactionStatus.success,
        transactions: result,
      ),
    );
  }
}

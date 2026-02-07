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

    final result = await transactionRepository.getAllTransactions();
    emit(
      state.copyWith(transactions: result, status: TransactionStatus.success),
    );
  }

  void onTabSelected(TransactionTabs tab) async {
    if (state.selectedTab == tab) return;

    emit(state.copyWith(status: TransactionStatus.loading, selectedTab: tab));

    final result = await switch (tab) {
      TransactionTabs.all => transactionRepository.getAllTransactions(),
      TransactionTabs.incomes => transactionRepository.getAllTransactionsByType(
        TransactionType.income,
      ),

      TransactionTabs.expenses =>
        transactionRepository.getAllTransactionsByType(TransactionType.expense),
    };

    emit(
      state.copyWith(status: TransactionStatus.success, transactions: result),
    );
  }

  void setSelectedDate(Month month, int year){
    emit(state.copyWith(selectedMonth: month, selectedYear: year));
  }
}

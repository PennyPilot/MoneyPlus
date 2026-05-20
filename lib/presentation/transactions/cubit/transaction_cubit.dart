import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/domain/entity/transaction.dart';
import 'package:moneyplus/domain/entity/transaction_type.dart';
import 'package:moneyplus/domain/repository/transaction_repository.dart';
import 'package:moneyplus/presentation/transactions/cubit/transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionRepository transactionRepository;

  TransactionCubit({required this.transactionRepository})
    : super(TransactionState.initial());

  void loadData({List<int>? initialCategories}) async {
    emit(state.copyWith(
      status: TransactionStatus.loading,
      selectedCategories: initialCategories,
      selectedTab: initialCategories==null?
          null:TransactionTabs.expenses
    ));

    final now = DateTime.now();
    try {
      final categories = await transactionRepository.getTransactionCategories();

      final result = await transactionRepository.getTransactions(
        page: 1,
        date: now,
        categoriesId: initialCategories?? List.empty(),
      );

      categories.when(
        onSuccess: (categories) {
          emit(
            state.copyWith(
              transactions: result,
              selectedYear: now.year,
              selectedMonth: now.month,
              status: TransactionStatus.success,
              hasMore: result.length == 20,
              transactionCategories: categories,
            ),
          );
        },
        onError: (error) {
          emit(state.copyWith(status: TransactionStatus.failure));
        },
      );
    } catch (_) {
      emit(state.copyWith(status: TransactionStatus.failure));
    }
  }

  void onCategoriesSelected(List<int> categories) async {
    if (categories == state.selectedCategories) return;
    emit(
      state.copyWith(
        selectedCategories: categories,
        status: TransactionStatus.loading,
        currentPage: 1,
        hasMore: true,
      ),
    );

    try {
      final result = await _getTransaction(
        page: 1,
        tab: state.selectedTab,
        year: state.selectedYear,
        month: state.selectedMonth,
        selectedCategories: categories,
      );

      emit(
        state.copyWith(
          status: TransactionStatus.success,
          transactions: result,
          currentPage: 1,
          hasMore: result.length == 20,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: TransactionStatus.failure));
    }
  }

  void onTabSelected(TransactionTabs tab) async {
    if (state.selectedTab == tab) return;

    emit(
      state.copyWith(
        status: TransactionStatus.loading,
        selectedTab: tab,
        currentPage: 1,
        hasMore: true,
      ),
    );

    try {
      final result = await _getTransaction(
        page: 1,
        tab: tab,
        year: state.selectedYear,
        month: state.selectedMonth,
        selectedCategories: state.selectedCategories,
      );

      emit(
        state.copyWith(
          status: TransactionStatus.success,
          transactions: result,
          currentPage: 1,
          hasMore: result.length == 20,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: TransactionStatus.failure));
    }
  }

  void setSelectedDate(int month, int year) async {
    if (state.selectedMonth == month && state.selectedYear == year) return;

    emit(
      state.copyWith(
        selectedMonth: month,
        selectedYear: year,
        status: TransactionStatus.loading,
        currentPage: 1,
        hasMore: true,
      ),
    );

    try {
      final result = await _getTransaction(
        page: 1,
        tab: state.selectedTab,
        year: year,
        month: month,
        selectedCategories: state.selectedCategories,
      );

      emit(
        state.copyWith(
          status: TransactionStatus.success,
          transactions: result,
          currentPage: 1,
          hasMore: result.length == 20,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: TransactionStatus.failure));
    }
  }

  void refresh() async {
    emit(
      state.copyWith(
        status: TransactionStatus.loading,
        currentPage: 1,
        hasMore: true,
      ),
    );

    try {
      final result = await _getTransaction(
        page: 1,
        tab: state.selectedTab,
        year: state.selectedYear,
        month: state.selectedMonth,
        selectedCategories: state.selectedCategories,
      );

      emit(
        state.copyWith(
          status: TransactionStatus.success,
          transactions: result,
          currentPage: 1,
          hasMore: result.length == 20,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: TransactionStatus.failure));
    }
  }

  void loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.currentPage + 1;

    try {
      final result = await _getTransaction(
        page: nextPage,
        tab: state.selectedTab,
        year: state.selectedYear,
        month: state.selectedMonth,
        selectedCategories: state.selectedCategories,
      );

      emit(
        state.copyWith(
          transactions: [...state.transactions, ...result],
          currentPage: nextPage,
          hasMore: result.length == 20,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: TransactionStatus.failure));
    }
  }

  Future<List<Transaction>> _getTransaction({
    required int page,
    required TransactionTabs tab,
    required int year,
    required int month,
    required List<int> selectedCategories,
  }) async {
    return await transactionRepository.getTransactions(
      page: page,
      type: tab == TransactionTabs.expenses
          ? TransactionType.expense
          : tab == TransactionTabs.incomes
          ? TransactionType.income
          : null,
      date: DateTime(year, month),
      categoriesId: selectedCategories,
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:moneyplus/core/errors/error_model.dart';
import 'package:moneyplus/domain/entity/transaction.dart';

enum TransactionStatus { initial, loading, success, failure }

enum TransactionTabs { all, incomes, expenses }

@immutable
class TransactionState {
  final TransactionStatus status;
  final ErrorModel? error;
  final List<Transaction> transactions;
  final TransactionTabs selectedTab;
  final int selectedMonth;
  final int selectedYear;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  const TransactionState({
    required this.status,
    this.error,
    this.transactions = const [],
    this.selectedTab = TransactionTabs.all,
    this.selectedYear = 2026,
    this.selectedMonth = 1,
    this.currentPage = 1,
    this.hasMore = true,
    this.isLoadingMore = false
  });

  factory TransactionState.initial() =>
      const TransactionState(status: TransactionStatus.initial);

  TransactionState copyWith({
    TransactionStatus? status,
    ErrorModel? error,
    List<Transaction>? transactions,
    TransactionTabs? selectedTab,
    int? selectedYear,
    int? selectedMonth,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore
  }) {
    return TransactionState(
      status: status ?? this.status,
      error: error,
      transactions: transactions ?? this.transactions,
      selectedTab: selectedTab ?? this.selectedTab,
      selectedYear: selectedYear ?? this.selectedYear,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore
    );
  }
}

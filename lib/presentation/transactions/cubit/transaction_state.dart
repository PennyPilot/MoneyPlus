import 'package:flutter/cupertino.dart';
import 'package:moneyplus/core/errors/error_model.dart';
import 'package:moneyplus/domain/entity/transaction.dart';

enum TransactionStatus { initial, loading, success, failure }
enum TransactionTabs { all, incomes, expenses }

@immutable
class TransactionState {
  final TransactionStatus status;
  final ErrorModel? error;
  final List<Transaction> filteredTransactions;
  final List<Transaction> allTransactions;
  final TransactionTabs selectedTab;
  final Month selectedMonth;
  final int selectedYear;

  const TransactionState({
    required this.status,
    this.error,
    this.filteredTransactions = const [],
    this.allTransactions = const [],
    this.selectedTab = TransactionTabs.all,
    this.selectedYear = 2026,
    this.selectedMonth = Month.january
  });

  factory TransactionState.initial() =>
      const TransactionState(status: TransactionStatus.initial);

  TransactionState copyWith({
    TransactionStatus? status,
    ErrorModel? error,
    List<Transaction>? filteredTransactions,
    List<Transaction>? allTransactions,
    TransactionTabs? selectedTab,
    int? selectedYear,
    Month? selectedMonth
  }) {
    return TransactionState(
      status: status ?? this.status,
      error: error,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      allTransactions: allTransactions ?? this.allTransactions,
      selectedTab: selectedTab ?? this.selectedTab,
      selectedYear: selectedYear ?? this.selectedYear,
      selectedMonth: selectedMonth ?? this.selectedMonth
    );
  }
}

enum Month {
  january('January'),
  february('February'),
  march('March'),
  april('April'),
  may('May'),
  june('June'),
  july('July'),
  august('August'),
  september('September'),
  october('October'),
  november('November'),
  december('December');

  final String label;

  const Month(this.label);
}
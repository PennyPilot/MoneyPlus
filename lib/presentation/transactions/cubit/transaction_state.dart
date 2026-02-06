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

  const TransactionState({
    required this.status,
    this.error,
    this.transactions = const [],
    this.selectedTab = TransactionTabs.all
  });

  factory TransactionState.initial() =>
      const TransactionState(status: TransactionStatus.initial);

  TransactionState copyWith({
    TransactionStatus? status,
    ErrorModel? error,
    List<Transaction>? transactions,
    TransactionTabs? selectedTab
  }) {
    return TransactionState(
      status: status ?? this.status,
      error: error,
      transactions: transactions ?? this.transactions,
      selectedTab: selectedTab ?? this.selectedTab
    );
  }
}

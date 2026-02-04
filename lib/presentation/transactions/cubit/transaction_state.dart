import 'package:flutter/cupertino.dart';
import 'package:moneyplus/core/errors/error_model.dart';
import 'package:moneyplus/domain/entity/transaction.dart';

enum TransactionStatus { initial, loading, success, failure }

@immutable
class TransactionState {
  final TransactionStatus status;
  final ErrorModel? error;
  final List<Transaction> transactions;

  const TransactionState({
    required this.status,
    this.error,
    this.transactions = const [],
  });

  factory TransactionState.initial() =>
      const TransactionState(status: TransactionStatus.initial);

  TransactionState copyWith({
    TransactionStatus? status,
    ErrorModel? error,
    List<Transaction>? transactions,
  }) {
    return TransactionState(
      status: status ?? this.status,
      error: error,
      transactions: transactions ?? this.transactions,
    );
  }
}

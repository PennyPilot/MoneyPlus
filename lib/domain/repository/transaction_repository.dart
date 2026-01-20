import 'dart:ffi';

import 'package:moneyplus/domain/entity/transaction.dart';
import 'package:moneyplus/domain/entity/transaction_category.dart';
import 'package:moneyplus/domain/entity/transaction_type.dart';
import 'package:moneyplus/domain/repository/model/top_spending_category.dart';

abstract class TransactionRepository {
  Future<Bool> addTransaction({
    required Double amount,
    required TransactionType type,
    required DateTime date,
    required TransactionCategory category,
    String note = "",
  });

  Future<Bool> editTransaction({
    required int id,
    Double? amount,
    TransactionType? type,
    DateTime? date,
    TransactionCategory? category,
    String? note,
  });

  Future<Bool> deleteTransaction(int id);

  Future<List<Transaction>> getTransactions({
    TransactionType? type,
    TransactionCategory? category,
    DateTime? date,
  });

  Future<Transaction> getTransactionDetails(int id);

  Future<Double> getTotalAmount({TransactionType? type});

  Future<List<TransactionCategory>> getTransactionCategories(
    TransactionType? type,
  );

  Future<List<TopSpendingCategory>> getTopSpendingCategories();

  Future<Bool> addExpenseCategory(String name);

  Future<Bool> editExpenseCategory({required int id, required String name});
}

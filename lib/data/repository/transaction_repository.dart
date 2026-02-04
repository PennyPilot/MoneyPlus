import 'dart:ffi';

import 'package:moneyplus/domain/entity/transaction.dart';
import 'package:moneyplus/domain/entity/transaction_category.dart';
import 'package:moneyplus/domain/entity/transaction_type.dart';
import 'package:moneyplus/domain/repository/model/top_spending_category.dart';
import 'package:moneyplus/domain/repository/transaction_repository.dart';

class TransactionRepositoryImpl extends TransactionRepository {
  @override
  Future<Bool> addExpenseCategory(String name) {
    // TODO: implement addExpenseCategory
    throw UnimplementedError();
  }

  @override
  Future<Bool> addTransaction({
    required Double amount,
    required TransactionType type,
    required DateTime date,
    required TransactionCategory category,
    String note = "",
  }) {
    // TODO: implement addTransaction
    throw UnimplementedError();
  }

  @override
  Future<Bool> deleteTransaction(int id) {
    // TODO: implement deleteTransaction
    throw UnimplementedError();
  }

  @override
  Future<Bool> editExpenseCategory({required int id, required String name}) {
    // TODO: implement editExpenseCategory
    throw UnimplementedError();
  }

  @override
  Future<Bool> editTransaction({
    required int id,
    Double? amount,
    TransactionType? type,
    DateTime? date,
    TransactionCategory? category,
    String? note,
  }) {
    // TODO: implement editTransaction
    throw UnimplementedError();
  }

  @override
  Future<List<Transaction>> getAllTransactions() async {
    return [
      Transaction(
        id: 1,
        amount: 50000,
        currency: "IQD",
        type: TransactionType.expense,
        date: DateTime(2024, 12, 2),
        category: TransactionCategory(id: 1, name: "shopping"),
      ),
      Transaction(
        id: 4,
        amount: 5040,
        currency: "IQD",
        type: TransactionType.income,
        date: DateTime(2024, 12, 2),
        category: TransactionCategory(id: 1, name: "shopping"),
      ),
      Transaction(
        id: 2,
        amount: 230000,
        currency: "IQD",
        type: TransactionType.income,
        date: DateTime(2024, 12, 2),
        category: TransactionCategory(id: 1, name: "shopping"),
      ),
      Transaction(
        id: 3,
        amount: 530000,
        currency: "IQD",
        type: TransactionType.expense,
        date: DateTime(2024, 12, 2),
        category: TransactionCategory(id: 1, name: "shopping"),
      ),
    ];
  }

  @override
  Future<List<Transaction>> getAllTransactionsByType(
    TransactionType type,
  ) async {
    if (type == TransactionType.income) {
      return [
        Transaction(
          id: 4,
          amount: 5040,
          currency: "IQD",
          type: TransactionType.income,
          date: DateTime(2024, 12, 2),
          category: TransactionCategory(id: 1, name: "shopping"),
        ),
        Transaction(
          id: 2,
          amount: 230000,
          currency: "IQD",
          type: TransactionType.income,
          date: DateTime(2024, 12, 2),
          category: TransactionCategory(id: 1, name: "shopping"),
        ),
      ];
    } else {
      return [
        Transaction(
          id: 1,
          amount: 50000,
          currency: "IQD",
          type: TransactionType.expense,
          date: DateTime(2024, 12, 2),
          category: TransactionCategory(id: 1, name: "shopping"),
        ),
        Transaction(
          id: 3,
          amount: 530000,
          currency: "IQD",
          type: TransactionType.expense,
          date: DateTime(2024, 12, 2),
          category: TransactionCategory(id: 1, name: "shopping"),
        ),
      ];
    }
  }

  @override
  Future<List<TopSpendingCategory>> getTopSpendingCategories() {
    // TODO: implement getTopSpendingCategories
    throw UnimplementedError();
  }

  @override
  Future<Double> getTotalAmount({TransactionType? type}) {
    // TODO: implement getTotalAmount
    throw UnimplementedError();
  }

  @override
  Future<List<TransactionCategory>> getTransactionCategories(
    TransactionType? type,
  ) {
    // TODO: implement getTransactionCategories
    throw UnimplementedError();
  }

  @override
  Future<Transaction> getTransactionDetails(int id) {
    // TODO: implement getTransactionDetails
    throw UnimplementedError();
  }

  @override
  Future<List<Transaction>> getTransactions({
    TransactionType? type,
    TransactionCategory? category,
    DateTime? date,
  }) {
    // TODO: implement getTransactions
    throw UnimplementedError();
  }
}

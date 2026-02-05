import 'package:moneyplus/domain/entity/transaction.dart';
import 'package:moneyplus/domain/entity/transaction_category.dart';
import 'package:moneyplus/domain/entity/transaction_type.dart';
import 'package:moneyplus/domain/repository/model/top_spending_category.dart';

abstract class TransactionRepository {
  Future<bool> addTransaction({
    required double amount,
    required TransactionType type,
    required DateTime date,
    required TransactionCategory category,
    String note = "",
  });

  Future<bool> editTransaction({
    required int id,
    double? amount,
    TransactionType? type,
    DateTime? date,
    TransactionCategory? category,
    String? note,
  });

  Future<bool> deleteTransaction(int id);

  Future<List<Transaction>> getTransactions({
    TransactionType? type,
    TransactionCategory? category,
    DateTime? date,
  });

  Future<Transaction> getTransactionDetails(int id);

  Future<double> getTotalAmount({TransactionType? type});

  Future<List<TransactionCategory>> getTransactionCategories(
    TransactionType? type,
  );

  Future<List<TopSpendingCategory>> getTopSpendingCategories();

  Future<bool> addExpenseCategory(String name);

  Future<bool> editExpenseCategory({required int id, required String name});
}

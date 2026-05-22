import 'package:moneyplus/domain/entity/transaction.dart';
import 'package:moneyplus/domain/entity/transaction_category.dart';
import 'package:moneyplus/domain/entity/transaction_type.dart';
import 'package:moneyplus/domain/repository/model/currency_rate.dart';
import 'package:moneyplus/domain/repository/model/top_spending_category.dart';

import '../../core/errors/result.dart';
import '../entity/currency.dart';

abstract class TransactionRepository {
  Future<Result<void>> upsertTransaction({
    String? id,
    required double amount,
    required TransactionType type,
    required DateTime date,
    required TransactionCategory category,
    required Currency currency,
    String note = "",
  });

  Future<List<CurrencyRate>> getExchangeRate({
    required int baseCurrencyId,
    required DateTime date,
  });

  Future<void> deleteTransaction(String id);

  Future<List<Transaction>> getTransactions({
    TransactionType? type,
    TransactionCategory? category,
    DateTime? date,
    List<int> categoriesId = const[],
    required int page,
  });

  Future<Result<Transaction>> getTransactionDetails(String id);

  Future<double> getTotalAmount({TransactionType? type});

  Future<Result<List<TransactionCategory>>> getTransactionCategories({
    TransactionType? type,
  });

  Future<Result<List<TransactionCategory>>> getDefaultTransactionCategories({
    TransactionType? type,
  });

  Future<List<TopSpendingCategory>> getTopSpendingCategories();

  Future<bool> addExpenseCategory(String name);

  Future<bool> editExpenseCategory({required int id, required String name});
}
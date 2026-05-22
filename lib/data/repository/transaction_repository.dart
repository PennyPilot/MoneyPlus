import 'package:moneyplus/core/errors/error_model.dart';
import 'package:moneyplus/core/errors/result.dart';
import 'package:moneyplus/domain/entity/transaction.dart';
import 'package:moneyplus/domain/entity/transaction_category.dart';
import 'package:moneyplus/domain/entity/transaction_type.dart';
import 'package:moneyplus/domain/repository/model/currency_rate.dart';
import 'package:moneyplus/domain/repository/model/top_spending_category.dart';
import 'package:moneyplus/domain/repository/transaction_repository.dart';
import 'package:moneyplus/domain/service/transaction_service.dart';

import '../../domain/entity/currency.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionService service;

  TransactionRepositoryImpl({required this.service});

  @override
  Future<Result<void>> upsertTransaction({
    String? id,
    required double amount,
    required TransactionType type,
    required DateTime date,
    required TransactionCategory category,
    required Currency currency,
    String note = "",
  }) async {
    return service.upsertTransaction(
      id: id,
      amount: amount,
      typeId: type.value,
      date: date,
      categoryId: category.id,
      currencyId: currency.id,
      note: note,
    );
  }

  @override
  Future<List<CurrencyRate>> getExchangeRate({
    required int baseCurrencyId,
    required DateTime date,
  }) async {
    final response = await service.getExchangeRate(
      baseCurrencyId: baseCurrencyId,
      date: date,
    );
    final rates = response['rates'] as List;
    return rates.map((e) => CurrencyRate.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> deleteTransaction(String id) {
    return service.deleteTransaction(id);
  }

  @override
  Future<List<Transaction>> getTransactions({
    TransactionType? type,
    TransactionCategory? category,
    DateTime? date,
    List<int>? categoriesId,
    required int page,
  }) async {
    final response = await service.getTransactions(
      typeId: type?.value,
      date: date,
      categoriesId: categoriesId,
      page: page,
    );
    return response
        .map((transaction) => Transaction.fromJson(transaction))
        .toList();
  }

  @override
  Future<Result<Transaction>> getTransactionDetails(String id) async {
    final data = await service.getTransactionDetails(id);
    if (data.isEmpty) {
      return Result.error(ErrorModel("no transaction with that id: $id"));
    }

    return Result.success(Transaction.fromJson(data));
  }

  @override
  Future<double> getTotalAmount({TransactionType? type}) async {
    throw UnimplementedError('getTotalAmount not implemented');
  }

  @override
  Future<Result<List<TransactionCategory>>> getTransactionCategories({
    TransactionType? type,
  }) async {
    try {
      final isIncome = type == null ? null : type == TransactionType.income;
      final data = await service.getTransactionCategories(isIncome: isIncome);

      final categories = data
          .map((e) => TransactionCategory.fromJson(e))
          .toList();
      return Result.success(categories);
    } catch (e) {
      return Result.error(ErrorModel('Failed to fetch categories: $e'));
    }
  }

  @override
  Future<Result<List<TransactionCategory>>> getDefaultTransactionCategories({
    TransactionType? type,
  }) async {
    try {
      final isIncome = type == null ? null : type == TransactionType.income;
      final data = await service.getDefaultTransactionCategories(isIncome: isIncome);

      final categories = data
          .map((e) => TransactionCategory.fromJson(e))
          .toList();
      return Result.success(categories);
    } catch (e) {
      return Result.error(ErrorModel('Failed to fetch default categories: $e'));
    }
  }

  @override
  Future<List<TopSpendingCategory>> getTopSpendingCategories() async {
    throw UnimplementedError('getTopSpendingCategories not implemented');
  }

  @override
  Future<bool> addExpenseCategory(String name) async {
    throw UnimplementedError('addExpenseCategory not implemented');
  }

  @override
  Future<bool> editExpenseCategory({
    required int id,
    required String name,
  }) async {
    throw UnimplementedError('editExpenseCategory not implemented');
  }
}

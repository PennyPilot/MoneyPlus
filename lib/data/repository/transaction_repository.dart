import 'package:moneyplus/core/errors/error_model.dart';
import 'package:moneyplus/core/errors/result.dart';
import 'package:moneyplus/domain/entity/transaction.dart';
import 'package:moneyplus/domain/entity/transaction_category.dart';
import 'package:moneyplus/domain/entity/transaction_type.dart';
import 'package:moneyplus/domain/repository/model/top_spending_category.dart';
import 'package:moneyplus/domain/repository/transaction_repository.dart';

import '../../core/service/supabase_service.dart';
import '../../domain/entity/currency.dart';


class TransactionRepositoryImpl implements TransactionRepository {
  final SupabaseService service;

  TransactionRepositoryImpl({required this.service});

  @override
  Future<Result<void>> addTransaction({
    required double amount,
    required TransactionType type,
    required DateTime date,
    required TransactionCategory category,
    required Currency currency,
    String note = "",
  }) async {
    try {
      final client = await service.getClient();
      await client.rpc(
        'add_transaction',
        params: {
          'amount': amount,
          'transaction_type_id': type.value,
          'date': date.toIso8601String(),
          'category_id': category.id,
          'note': note,
          'currency_id': currency.id,
        },
      );
      return Result.success(null);
    } catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<bool> editTransaction({
    required int id,
    double? amount,
    TransactionType? type,
    DateTime? date,
    TransactionCategory? category,
    String? note,
  }) async {
    throw UnimplementedError('editTransaction not implemented');
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final client = await service.getClient();

    final response = await client.rpc(
      RpcString.deleteTransaction,
      params: {'p_id': id},
    );
    if (response == null || response['id'] == null) {
      throw Exception("cannot delete transaction with id: $id ");
    }
  }

  @override
  Future<List<Transaction>> getTransactions({
    TransactionType? type,
    TransactionCategory? category,
    DateTime? date,
  }) async {
    throw UnimplementedError('getTransactions not implemented');
  }

  @override
  Future<Result<Transaction>> getTransactionDetails(String id) async {
    final client = await service.getClient();
    final response = await client.rpc(
      RpcString.getTransactionDetails,
      params: {'p_id': id},
    );
    final data = response as Map<String, dynamic>;
    if (data.isEmpty) {
      return Result.error(ErrorModel("no transaction with that id: $id"));
    }
    final transactionType = ((data['transaction_type_id'] as int) == 1)
        ? TransactionType.income
        : TransactionType.expense;
    return Result.success(
      Transaction(
        id: 0,
        amount: (data['amount'] as num).toDouble(),
        currency: await _getCurrencyAbbreviation(data['currency_id'] as int),
        type: transactionType,
        date: DateTime.parse(data['created_at']).toLocal(),
        category: TransactionCategory(
          id: data['category_id'] as int,
          name: await _getCategoryName((data['category_id'] as int).toString()),
        ),
        note: data['note'] as String,
      ),
    );
  }

  Future<String> _getCurrencyAbbreviation(int currencyId) async {
    final client = await service.getClient();

    final response = await client
        .from('currencies')
        .select('abbreviation')
        .eq('id', currencyId)
        .maybeSingle();

    if (response == null) {
      throw Exception("No currency found with id: $currencyId");
    }

    return response['abbreviation'] as String;
  }

  Future<String> _getCategoryName(String categoryId) async {
    final client = await service.getClient();

    final response = await client
        .from('categories')
        .select('name')
        .eq('id', categoryId)
        .maybeSingle();

    if (response == null) {
      throw Exception("No category found with id: $categoryId");
    }

    return response['name'] as String;
  }

  @override
  Future<double> getTotalAmount({TransactionType? type}) async {
    throw UnimplementedError('getTotalAmount not implemented');
  }

  @override
  Future<List<TransactionCategory>> getTransactionCategories(
    TransactionType? type,
  ) async {
    try {
      final client = await service.getClient();
      final response = await client.from('categories').select();
      return response.map((e) => TransactionCategory.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to fetch categories');
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

  @override
  Future<List<Transaction>> getAllTransactions() async {
    await Future.delayed(const Duration(milliseconds: 500));
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
    await Future.delayed(const Duration(milliseconds: 500));
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
}

class RpcString {
  static String deleteTransaction = 'delete_transaction';
  static String getTransactionDetails = 'get_transaction_details';
}

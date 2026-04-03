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
  Future<Result<void>> addIncomeTransaction({
    required double amount,
    required DateTime date,
    TransactionCategory? category,
    required Currency currency,
    String note = "",
  }) async {
    try {
      final client = await service.getClient();
      await client.rpc(
        'add_transaction',
        params: {
          'amount': amount,
          'transaction_type_id': TransactionType.income.value,
          'date': date.toIso8601String(),
          'category_id': DefaultTransactionTypeId.income,
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
    List<int>? categoriesId,
    required int page,
  }) async {
    final client = await service.getClient();
    final response = await client.rpc(
      RpcString.getTransactions,
      params: {
        'p_timestamp': date?.toIso8601String(),
        'p_category_ids': categoriesId,
        'p_transaction_type_id': type?.value,
        'p_page': page,
      },
    );
    return (response as List)
        .map((transaction) => Transaction.fromJson(transaction))
        .toList();
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
  Future<Result<List<TransactionCategory>>> getTransactionCategories({
    TransactionType? type,
  }) async {
    try {
      final isIncome = type == null ? null : type == TransactionType.income;

      final client = await service.getClient();
      final data = await client.rpc(
        RpcString.getUserCategories,
        params: {'p_is_income': isIncome},
      );

      final categories = (data as List<dynamic>)
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

      final client = await service.getClient();
      final data = await client.rpc(
        RpcString.getDefaultCategories,
        params: {'p_is_income': isIncome},
      );

      if (data == null) {
        return Result.success([]);
      }
      final categories = (data as List<dynamic>)
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

class RpcString {
  static String deleteTransaction = 'delete_transaction';
  static String getTransactionDetails = 'get_transaction_details';
  static String getTransactions = 'get_transactions';
  static String getDefaultCategories = 'get_default_categories';
  static String getUserCategories = 'get_user_categories';
}

class DefaultTransactionTypeId {
  static int income = 27;
}
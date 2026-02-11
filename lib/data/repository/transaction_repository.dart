import 'package:moneyplus/core/errors/result.dart';
import 'package:moneyplus/domain/entity/transaction.dart';
import 'package:moneyplus/domain/entity/transaction_category.dart';
import 'package:moneyplus/domain/entity/transaction_type.dart';
import 'package:moneyplus/domain/repository/model/top_spending_category.dart';
import 'package:moneyplus/domain/repository/transaction_repository.dart';

import '../service/supabase_service.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final SupabaseService service;

  TransactionRepositoryImpl({required this.service});
  @override
  Future<Result<void>> addTransaction({
    required double amount,
    required TransactionType type,
    required DateTime date,
    required TransactionCategory category,
    String note = "",
  }) async {
    try {
      final client = await service.getClient();
      await client.rpc(
          'add_transaction',
          params: {'amount': amount, 'transaction_type': type.index + 1 }
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
  Future<bool> deleteTransaction(int id) async {
    throw UnimplementedError('deleteTransaction not implemented');
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
  Future<Transaction> getTransactionDetails(int id) async {
    throw UnimplementedError('getTransactionDetails not implemented');
  }

  @override
  Future<double> getTotalAmount({TransactionType? type}) async {
    throw UnimplementedError('getTotalAmount not implemented');
  }

  @override
  Future<List<TransactionCategory>> getTransactionCategories(
    TransactionType? type,
  ) async {
    try{
      final client = await service.getClient();
      final response = await client.from('categories').select();
      return response.map((e) => TransactionCategory.fromJson(e)).toList();
    }catch(e){
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

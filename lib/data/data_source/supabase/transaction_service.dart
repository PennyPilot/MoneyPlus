import '../../../core/errors/result.dart';
import '../../../core/service/supabase_service.dart';
import '../../../domain/service/transaction_service.dart';

class SupabaseTransactionService implements TransactionService {
  final SupabaseService service;

  SupabaseTransactionService({required this.service});

  @override
  Future<Result<void>> upsertTransaction({
    String? id,
    required double amount,
    required int typeId,
    required DateTime date,
    required int categoryId,
    required int currencyId,
    String note = "",
  }) async {
    try {
      final client = await service.getClient();
      await client.functions.invoke(
        'upsert_transaction',
        body: {
          'id': id,
          'amount': amount,
          'transaction_type_id': typeId,
          'date': date.toIso8601String(),
          'category_id': categoryId,
          'note': note,
          'currency_id': currencyId,
        },
      );
      return Result.success(null);
    } catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getExchangeRate({
    required int baseCurrencyId,
    required DateTime date,
  }) async {
    final client = await service.getClient();
    final response = await client.functions.invoke(
      'get_exchange_rate',
      body: {
        'base_currency': baseCurrencyId,
        'date': date.toIso8601String().split('T')[0],
      },
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final client = await service.getClient();
    final response = await client.rpc(
      'delete_transaction',
      params: {'p_id': id},
    );
    if (response == null || response['id'] == null) {
      throw Exception("cannot delete transaction with id: $id ");
    }
  }

  @override
  Future<List<dynamic>> getTransactions({
    int? typeId,
    DateTime? date,
    List<int>? categoriesId,
    required int page,
  }) async {
    final client = await service.getClient();
    final response = await client.rpc(
      'get_transactions',
      params: {
        'p_timestamp': date?.toIso8601String(),
        'p_category_ids': categoriesId,
        'p_transaction_type_id': typeId,
        'p_page': page,
      },
    );
    return response as List;
  }

  @override
  Future<Map<String, dynamic>> getTransactionDetails(String id) async {
    final client = await service.getClient();
    final response = await client.rpc(
      'get_transaction_details',
      params: {'p_transaction_id': id},
    );
    return response as Map<String, dynamic>;
  }

  @override
  Future<List<dynamic>> getTransactionCategories({bool? isIncome}) async {
    final client = await service.getClient();
    final data = await client.rpc(
      'get_user_categories',
      params: {'p_is_income': isIncome},
    );
    return data as List<dynamic>;
  }

  @override
  Future<List<dynamic>> getDefaultTransactionCategories({bool? isIncome}) async {
    final client = await service.getClient();
    final data = await client.rpc(
      'get_default_categories',
      params: {'p_is_income': isIncome},
    );
    return data as List<dynamic>;
  }
}

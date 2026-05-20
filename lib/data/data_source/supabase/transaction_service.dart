import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/errors/result.dart';
import '../../../core/service/supabase_service.dart';
import '../../../domain/service/transaction_service.dart';

class SupabaseTransactionService implements TransactionService {
  final SupabaseService service;

  SupabaseTransactionService({required this.service});

  @override
  Future<Result<void>> addTransaction({
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
        'add_transaction',
        body: {
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
  Future<bool> editTransaction({
    required String id,
    double? amount,
    int? typeId,
    DateTime? date,
    int? categoryId,
    String? note,
  }) async {
    try {
      final client = await service.getClient();
      final Map<String, dynamic> updates = {};
      if (amount != null) updates['amount'] = amount;
      if (typeId != null) updates['transaction_type_id'] = typeId;
      if (date != null) updates['date'] = date.toIso8601String();
      if (categoryId != null) updates['category_id'] = categoryId;
      if (note != null) updates['note'] = note;

      if (updates.isEmpty) return true;

      await client.from('transactions').update(updates).eq('id', id);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String> getCurrencyAbbreviation(int currencyId) async {
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

  @override
  Future<String> getCategoryName(String categoryId) async {
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

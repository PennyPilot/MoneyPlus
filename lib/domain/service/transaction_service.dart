import '../../core/errors/result.dart';

abstract class TransactionService {
  Future<Result<void>> upsertTransaction({
    String? id,
    required double amount,
    required int typeId,
    required DateTime date,
    required int categoryId,
    required int currencyId,
    String note = "",
  });

  Future<Map<String, dynamic>> getExchangeRate({
    required int baseCurrencyId,
    required DateTime date,
  });

  Future<void> deleteTransaction(String id);

  Future<List<dynamic>> getTransactions({
    int? typeId,
    DateTime? date,
    List<int>? categoriesId,
    required int page,
  });

  Future<Map<String, dynamic>> getTransactionDetails(String id);

  Future<List<dynamic>> getTransactionCategories({
    bool? isIncome,
  });

  Future<List<dynamic>> getDefaultTransactionCategories({
    bool? isIncome,
  });
}

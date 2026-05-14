import '../../core/errors/result.dart';

abstract class TransactionService {
  Future<Result<void>> addTransaction({
    required double amount,
    required int typeId,
    required DateTime date,
    required int categoryId,
    required int currencyId,
    String note = "",
  });

  Future<void> deleteTransaction(String id);

  Future<List<dynamic>> getTransactions({
    int? typeId,
    DateTime? date,
    List<int>? categoriesId,
    required int page,
  });

  Future<Map<String, dynamic>> getTransactionDetails(String id);

  Future<String> getCurrencyAbbreviation(int currencyId);

  Future<String> getCategoryName(String categoryId);

  Future<List<dynamic>> getTransactionCategories({
    bool? isIncome,
  });

  Future<List<dynamic>> getDefaultTransactionCategories({
    bool? isIncome,
  });
}

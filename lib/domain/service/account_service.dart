
abstract class AccountService {
  Future<List<dynamic>> getCurrencies();
  Future<void> completeAccountSetup({
    required String userId,
    required double salary,
    required int salaryDay,
    required int currencyId,
    required double initialBalance,
    required List<String> categories,
  });

  Future<void> updateCurrency(String userId, int currencyId);
}

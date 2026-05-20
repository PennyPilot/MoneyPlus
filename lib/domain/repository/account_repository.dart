import 'package:moneyplus/domain/entity/currency.dart';
import 'package:moneyplus/domain/entity/user.dart';

import '../../core/errors/result.dart';

abstract class AccountRepository {
  Future<List<Currency>> getCurrencies();

  Future<Result<User>> getCurrentUser();

  Future<void> completeAccountSetup({
    required String userId,
    required double salary,
    required int salaryDay,
    required int currencyId,
    required double initialBalance,
    required List<String> categories,
  });

  Future<void> updateCurrency(int currencyId);
}
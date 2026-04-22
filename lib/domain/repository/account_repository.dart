import 'package:moneyplus/domain/entity/currency.dart';
import 'package:moneyplus/domain/entity/user.dart';

import '../../core/errors/result.dart';

abstract class AccountRepository {
  Future<List<Currency>> getCurrencies();

  Future<Result<User>> getCurrentUser();
}
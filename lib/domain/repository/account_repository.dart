import 'package:moneyplus/domain/entity/currency.dart';
import 'package:moneyplus/domain/entity/user.dart';

abstract class AccountRepository {
  Future<List<Currency>> getCurrencies();
  
  Future<User> getCurrentUser();

}
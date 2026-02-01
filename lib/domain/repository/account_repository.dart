
import 'package:moneyplus/domain/entity/currency.dart';

abstract class AccountRepository {
  Future<List<Currency>> getCurrencies();
}

import 'package:moneyplus/domain/entity/currency.dart';

abstract class AccountSetupRepository {

  Future<List<Currency>> getCurrency();

}
import 'package:moneyplus/domain/entity/currency.dart';

import 'model/balance_status.dart';
import 'model/currency_breakdown.dart';

abstract class UserMoneyRepository {
  Future<BalanceStatus> getBalanceStatus({
    required int month,
    required int year,
  });

  Future<List<CurrencyBreakdown>> getCurrencyBreakdown({
    required int month,
    required int year,
  });

  Future<Currency> getCurrency();

  Future<double> getSalary();

  Future<int> getSalaryDay();

  Future<void> updateSalarySettings({
    required double salary,
    required int salaryDay,
  });
}

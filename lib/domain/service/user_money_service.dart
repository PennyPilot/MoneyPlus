import '../entity/currency.dart';

abstract class UserMoneyService {
  Future<dynamic> getBalanceStatusResponse({
    required int month,
    required int year,
  });

  Future<dynamic> getCurrencyBreakdownResponse({
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

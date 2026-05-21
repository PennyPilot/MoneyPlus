import '../entity/currency.dart';

abstract class UserMoneyService {
  Future<double> getMonthExpense(int month, int year);

  Future<double> getMonthIncome(int month, int year);

  Future<double> getTotalBalance();

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

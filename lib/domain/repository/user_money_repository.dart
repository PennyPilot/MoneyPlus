import 'package:moneyplus/domain/entity/currency.dart';

import 'model/currency_breakdown.dart';

abstract class UserMoneyRepository {
  Future<double> getTotalBalance();

  Future<double> getMonthIncome(int month, int year);

  Future<double> getMonthExpense(int month, int year);

  Future<List<CurrencyBreakdown>> getCurrencyBreakdown({
    required int month,
    required int year,
  });

  Future<Currency> getCurrency();

  Future<double> getSavingSpendingPercentage(
    int month,
    int year, {
    double? currentIncome,
    double? currentExpense,
  });

  Future<double> getSalary();

  Future<int> getSalaryDay();

  Future<void> updateSalarySettings({
    required double salary,
    required int salaryDay,
  });
}

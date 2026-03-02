import 'package:moneyplus/domain/entity/currency.dart';

import 'model/top_spending_category.dart';

abstract class UserMoneyRepository {
  Future<double> getTotalBalance();

  Future<double> getMonthIncome(int month, int year);

  Future<double> getMonthExpense(int month, int year);

  Future<List<TopSpendingCategory>> getTopSpendingCategoriesInMonth({
    required int month,
    required int year,
    required int count,
  });

  Future<Currency> getCurrency();

  Future<double> getSavingSpendingPercentage(int month, int year);

  Future<double> getSalary();

  Future<int> getSalaryDay();

  Future<void> updateSalarySettings({
    required double salary,
    required int salaryDay,
  });
}

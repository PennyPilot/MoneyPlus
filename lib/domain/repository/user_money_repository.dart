import 'model/month_enum.dart';
import 'model/top_spending_category.dart';

abstract class UserMoneyRepository {
  Future<double> getTotalBalance();

  Future<double> getMonthIncome(Month month, int year);

  Future<double> getMonthExpense(Month month, int year);

  Future<List<TopSpendingCategory>> getTopSpendingCategoriesInMonth(
      {required Month month,required int year, required int count});

  Future<String> getCurrency();

  Future<double> getSavingSpendingPercentage(Month month, int year);
}

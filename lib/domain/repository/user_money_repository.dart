import 'model/month_enum.dart';
import 'model/top_spending_category.dart';

abstract class UserMoneyRepository {
  Future<double> getTotalBalance();

  Future<double> getMonthIncome(Month month, int year);

  Future<double> getMonthExpense(Month month, int year);

  Future<List<TopSpendingCategory>> getTopSpendingCategoriesInMonth(Month month, int year);

  Future<String> getCurrency();

  Future<double> getSavingSpendingPercentage(Month month, int year);
}

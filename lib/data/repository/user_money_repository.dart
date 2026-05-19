import 'package:moneyplus/domain/entity/currency.dart';
import 'package:moneyplus/domain/entity/transaction_category.dart';
import 'package:moneyplus/domain/repository/model/top_spending_category.dart';
import 'package:moneyplus/domain/repository/user_money_repository.dart';
import 'package:moneyplus/domain/service/user_money_service.dart';

class UserRepositoryImpl implements UserMoneyRepository {
  final UserMoneyService service;

  UserRepositoryImpl({required this.service});

  @override
  Future<double> getMonthExpense(int month, int year) async {
    _validateMonth(month);
    return service.getMonthExpense(month, year);
  }

  @override
  Future<double> getMonthIncome(int month, int year) async {
    _validateMonth(month);
    return service.getMonthIncome(month, year);
  }

  @override
  Future<double> getTotalBalance() {
    return service.getTotalBalance();
  }

  @override
  Future<List<TopSpendingCategory>> getTopSpendingCategoriesInMonth({
    required int month,
    required int year,
    required int count,
  }) async {
    _validateMonth(month);
    final response = await service.getTopSpendingResponse(
      month: month,
      year: year,
      count: count,
    );
    final rows = response as List<dynamic>;
    if (rows.isEmpty) return List.empty();

    return _getTopSpendingCategoriesFromResponseRows(rows);
  }

  List<TopSpendingCategory> _getTopSpendingCategoriesFromResponseRows(
    List<dynamic> rows,
  ) {
    return rows.map((row) {
      final data = row as Map<String, dynamic>;
      return TopSpendingCategory(
        category: TransactionCategory(
          id: data['category_id'] as int,
          name: data['category_name'] as String,
        ),
        total: (data['total_amount'] as num).toDouble(),
        numberOfTransactions: (data['transactions_count'] as num).toInt(),
        percentage: (data['percentage'] as num).toDouble(),
        currency: data['currency_abbreviation'] as String,
      );
    }).toList();
  }

  @override
  Future<Currency> getCurrency() {
    return service.getCurrency();
  }

  @override
  Future<double> getSavingSpendingPercentage(int month, int year) async {
    _validateMonth(month);
    final isJanuary = month == 1;
    final previousMonth = isJanuary ? 12 : month - 1;
    final previousYear = isJanuary ? year - 1 : year;

    final [
      currentIncome,
      currentExpense,
      previousIncome,
      previousExpense,
    ] = await Future.wait([
      getMonthIncome(month, year),
      getMonthExpense(month, year),
      getMonthIncome(previousMonth, previousYear),
      getMonthExpense(previousMonth, previousYear),
    ]);

    final currentMonthBalance = currentIncome - currentExpense;
    final previousMonthBalance = previousIncome - previousExpense;

    if (previousMonthBalance == 0) {
      return 100;
    }
    return ((currentMonthBalance - previousMonthBalance) / previousMonthBalance) * 100;
  }

  @override
  Future<double> getSalary() {
    return service.getSalary();
  }

  @override
  Future<int> getSalaryDay() {
    return service.getSalaryDay();
  }

  @override
  Future<void> updateSalarySettings({
    required double salary,
    required int salaryDay,
  }) {
    return service.updateSalarySettings(salary: salary, salaryDay: salaryDay);
  }

  void _validateMonth(int month){
    if(month < 1 || month > 12){
      throw Exception('Month value: "$month" is not valid, Month must be between 1 and 12');
    }
  }
}

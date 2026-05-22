import 'package:moneyplus/domain/entity/currency.dart';
import 'package:moneyplus/domain/repository/model/balance_status.dart';
import 'package:moneyplus/domain/repository/model/currency_breakdown.dart';
import 'package:moneyplus/domain/repository/user_money_repository.dart';
import 'package:moneyplus/domain/service/user_money_service.dart';

class UserRepositoryImpl implements UserMoneyRepository {
  final UserMoneyService service;

  UserRepositoryImpl({required this.service});

  @override
  Future<BalanceStatus> getBalanceStatus({
    required int month,
    required int year,
  }) async {
    _validateMonth(month);
    final response = await service.getBalanceStatusResponse(
      month: month,
      year: year,
    );
    return BalanceStatus.fromJson(response as Map<String, dynamic>);
  }

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
  Future<List<CurrencyBreakdown>> getCurrencyBreakdown({
    required int month,
    required int year,
  }) async {
    _validateMonth(month);
    final response = await service.getCurrencyBreakdownResponse(
      month: month,
      year: year,
    );
    final rows = response as List<dynamic>;
    if (rows.isEmpty) return List.empty();

    return rows.map((row) => CurrencyBreakdown.fromJson(row as Map<String, dynamic>)).toList();
  }

  @override
  Future<Currency> getCurrency() {
    return service.getCurrency();
  }

  @override
  Future<double> getSavingSpendingPercentage(
    int month,
    int year, {
    double? currentIncome,
    double? currentExpense,
  }) async {
    _validateMonth(month);
    final isJanuary = month == 1;
    final previousMonth = isJanuary ? 12 : month - 1;
    final previousYear = isJanuary ? year - 1 : year;

    // Use provided values or fetch if null
    final double income = currentIncome ?? await getMonthIncome(month, year);
    final double expense = currentExpense ?? await getMonthExpense(month, year);

    final [
      previousIncome,
      previousExpense,
    ] = await Future.wait([
      getMonthIncome(previousMonth, previousYear),
      getMonthExpense(previousMonth, previousYear),
    ]);

    final currentMonthBalance = income - expense;
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

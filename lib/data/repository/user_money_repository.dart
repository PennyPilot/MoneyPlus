import 'package:moneyplus/domain/entity/currency.dart';
import 'package:moneyplus/domain/entity/transaction_category.dart';
import 'package:moneyplus/domain/repository/model/top_spending_category.dart';
import 'package:moneyplus/domain/repository/user_money_repository.dart';

import '../../core/service/supabase_service.dart';

class UserRepositoryImpl implements UserMoneyRepository {
  final SupabaseService service;

  UserRepositoryImpl({required this.service});

  @override
  Future<double> getMonthExpense(int month, int year) async {
    _validateMonth(month);
    final client = await service.getClient();
    final response = await client.rpc(
      'get_month_expense',
      params: {
        'p_month': month,
        'p_year': year,
      },
    );

    return (response as num).toDouble();
  }

  @override
  Future<double> getMonthIncome(int month, int year) async {
    _validateMonth(month);
    final client = await service.getClient();
    final response = await client.rpc(
      'get_month_income',
      params: {
        'p_month': month,
        'p_year': year,
      },
    );

    return (response as num).toDouble();
  }

  @override
  Future<double> getTotalBalance() async {
    final client = await service.getClient();
    final response = await client.from('users').select('current_balance');
    final balance = (response.firstOrNull?['current_balance'] as num?)?.toDouble() ?? 0.0;
    return balance;
  }

  @override
  Future<List<TopSpendingCategory>> getTopSpendingCategoriesInMonth({
    required int month,
    required int year,
    required int count,
  }) async {
    _validateMonth(month);
    final response = await _getTopSpendingResponse(
      month: month,
      year: year,
      count: count,
    );
    final rows = response as List<dynamic>;
    if (rows.isEmpty) return List.empty();

    return _getTopSpendingCategoriesFromResponseRows(rows);
  }

  Future<dynamic> _getTopSpendingResponse({
    required int month,
    required int year,
    required int count,
  }) async {
    final client = await service.getClient();

    final response = await client.rpc(
      'get_top_spending_categories',
      params: {'p_month': month, 'p_year': year, 'p_limit': count},
    );
    return response;
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
  Future<Currency> getCurrency() async {
    final client = await service.getClient();
    final response = await client.rpc('get_default_currency');
    return Currency.fromJson(response);
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
  Future<double> getSalary() async {
    final client = await service.getClient();
    final response = await client.from('users').select('salary_amount');
    final balance = (response.firstOrNull?['salary_amount'] as num?)?.toDouble() ?? 0.0;
    return balance;
  }

  @override
  Future<int> getSalaryDay() async {
    final client = await service.getClient();
    final response = await client.from('users').select('salary_day');
    final balance = (response.firstOrNull?['salary_day'] as int?)?.toInt() ?? 0;
    return balance;
  }

  @override
  Future<void> updateSalarySettings({
    required double salary,
    required int salaryDay,
  }) async {
    final client = await service.getClient();

    await client
        .from('users')
        .update({'salary_amount': salary, 'salary_day': salaryDay})
        .eq('id', client.auth.currentUser!.id);
  }

  void _validateMonth(int month){
    if(month < 1 || month > 12){
      throw Exception('Month value: "$month" is not valid, Month must be between 1 and 12');
    }
  }

}

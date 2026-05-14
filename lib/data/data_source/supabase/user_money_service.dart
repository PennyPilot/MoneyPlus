import '../../../core/service/supabase_service.dart';
import '../../../domain/entity/currency.dart';
import '../../../domain/service/user_money_service.dart';

class SupabaseUserMoneyService implements UserMoneyService {
  final SupabaseService service;

  SupabaseUserMoneyService({required this.service});

  @override
  Future<double> getMonthExpense(int month, int year) async {
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
    return (response.firstOrNull?['current_balance'] as num?)?.toDouble() ?? 0.0;
  }

  @override
  Future<dynamic> getTopSpendingResponse({
    required int month,
    required int year,
    required int count,
  }) async {
    final client = await service.getClient();
    return await client.rpc(
      'get_top_spending_categories',
      params: {'p_month': month, 'p_year': year, 'p_limit': count},
    );
  }

  @override
  Future<Currency> getCurrency() async {
    final client = await service.getClient();
    final response = await client.rpc('get_default_currency');
    return Currency.fromJson(response);
  }

  @override
  Future<double> getSalary() async {
    final client = await service.getClient();
    final response = await client.from('users').select('salary_amount');
    return (response.firstOrNull?['salary_amount'] as num?)?.toDouble() ?? 0.0;
  }

  @override
  Future<int> getSalaryDay() async {
    final client = await service.getClient();
    final response = await client.from('users').select('salary_day');
    return (response.firstOrNull?['salary_day'] as int?)?.toInt() ?? 0;
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
}

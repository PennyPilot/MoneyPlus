import '../../../core/service/supabase_service.dart';
import '../../../domain/service/account_service.dart';

class SupabaseAccountService implements AccountService {
  final SupabaseService service;

  SupabaseAccountService({required this.service});

  @override
  Future<List<dynamic>> getCurrencies() async {
    final client = await service.getClient();
    return await client.from('currencies').select();
  }

  @override
  Future<void> completeAccountSetup({
    required String userId,
    required double salary,
    required int salaryDay,
    required int currencyId,
    required double initialBalance,
    required List<String> categories,
  }) async {
    final client = await service.getClient();

    await client
        .from('users')
        .update({
          'salary_amount': salary,
          'salary_day': salaryDay,
          'default_currency_id': currencyId,
          'current_balance': initialBalance,
          'is_complete': true,
        })
        .eq('id', userId);

    final categoryData = categories
        .map((name) => {'name': name, 'user_id': userId, 'is_income': false})
        .toList();

    await client.from('categories').insert(categoryData);
  }
}

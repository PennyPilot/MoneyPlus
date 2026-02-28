import 'package:moneyplus/domain/entity/currency.dart';
import 'package:moneyplus/domain/entity/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../../domain/repository/account_repository.dart';
import '../../core/service/supabase_service.dart';

class AccountRepositoryImpl extends AccountRepository {
  final SupabaseService supabaseService;

  AccountRepositoryImpl({required this.supabaseService});

  @override
  Future<List<Currency>> getCurrencies() async {
    try {
      final client = await supabaseService.getClient();
      final response = await client.from('currencies').select();
      return response.map((e) => Currency.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to fetch currencies');
    }
  }

  @override
  Future<User> getCurrentUser() async {
      throw Exception('Failed to get current user');
  }

}
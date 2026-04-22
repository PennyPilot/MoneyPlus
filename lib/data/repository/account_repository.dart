import 'dart:developer';

import 'package:moneyplus/domain/entity/currency.dart';
import 'package:moneyplus/domain/entity/user.dart' as entity_user;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/errors/error_model.dart';
import '../../core/errors/result.dart';
import '../../core/errors/supabase_auth_error.dart';
import '../../core/service/supabase_service.dart';
import '../../domain/repository/account_repository.dart';

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
  Future<Result<entity_user.User>> getCurrentUser() async {
    try {
      final client = await supabaseService.getClient();
      final currentUser = client.auth.currentUser;

      if (currentUser == null) {
        return Result.error(ErrorModel('User not authenticated'));
      }
      final user = entity_user.User(
        id: currentUser.id,
        email: currentUser.email ?? '',
        name: currentUser.userMetadata?['name'] ?? '',
      );
      return Result.success(user);
    } catch (error) {
      log('error in data $error');
      return Result.error(ErrorModel(error.toString()));
    }
  }


}

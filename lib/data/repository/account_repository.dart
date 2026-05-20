import 'dart:developer';

import 'package:moneyplus/domain/entity/currency.dart';
import 'package:moneyplus/domain/entity/user.dart' as entity_user;

import '../../core/errors/error_model.dart';
import '../../core/errors/result.dart';
import '../../core/service/supabase_service.dart';
import '../../domain/repository/account_repository.dart';
import '../../domain/service/account_service.dart';

class AccountRepositoryImpl extends AccountRepository {
  final AccountService service;
  final SupabaseService supabaseService;

  AccountRepositoryImpl({
    required this.service,
    required this.supabaseService,
  });

  @override
  Future<List<Currency>> getCurrencies() async {
    try {
      final response = await service.getCurrencies();
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

  @override
  Future<void> completeAccountSetup({
    required String userId,
    required double salary,
    required int salaryDay,
    required int currencyId,
    required double initialBalance,
    required List<String> categories,
  }) {
    return service.completeAccountSetup(
      userId: userId,
      salary: salary,
      salaryDay: salaryDay,
      currencyId: currencyId,
      initialBalance: initialBalance,
      categories: categories,
    );
  }

  @override
  Future<void> updateCurrency(int currencyId) async {
    final client = await supabaseService.getClient();
    final userId = client.auth.currentUser?.id;
    if (userId != null) {
      await service.updateCurrency(userId, currencyId);
    }
  }
}

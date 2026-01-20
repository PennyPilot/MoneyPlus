import 'dart:async';

import 'package:moneyplus/core/app_constants.dart';
import 'package:moneyplus/data/service/app_secrets_provider.dart';
import 'package:moneyplus/data/service/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repository/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final SupabaseService supabaseService;
  final AppSecretsProvider appSecretsProvider;

  AuthenticationRepositoryImpl(this.supabaseService, this.appSecretsProvider);

  @override
  Future<void> resetPasswordForEmail(String email) async {
    final client = await supabaseService.getClient();
    await client.client.auth.resetPasswordForEmail(
      email,
      redirectTo: AppConstants.resetPasswordRedirect,
    );
  }

  @override
  Stream<AuthState> get onAuthStateChange {
    final supabaseClientFuture = supabaseService.getClient();
    return Stream.fromFuture(supabaseClientFuture).asyncExpand((supabase) {
      return supabase.client.auth.onAuthStateChange;
    });
  }

  @override
  Future<void> updatePassword(String password) async {
    final client = await supabaseService.getClient();
    await client.client.auth.updateUser(UserAttributes(password: password));
  }
}

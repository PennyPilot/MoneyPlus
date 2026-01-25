import 'package:moneyplus/data/service/supabase_service.dart';
import 'package:moneyplus/domain/entity/user.dart' as user_entity;

import '../../domain/repository/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final SupabaseService _supabaseService;

  AuthenticationRepositoryImpl(this._supabaseService);

  @override
  Future<void> register(user_entity.User user, String password) async {
    final client = await _supabaseService.getClient();
    await client.auth.signUp(
      email: user.email,
      password: password,
      data: {"name": user.username, "is_complete": false},
    );
  }
}

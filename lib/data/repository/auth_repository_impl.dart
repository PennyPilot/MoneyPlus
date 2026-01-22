import 'dart:developer';
import 'package:moneyplus/core/errors/result.dart';
import 'package:moneyplus/domain/entity/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../../core/errors/error_model.dart';
import '../../core/errors/supabase_auth_error.dart';
import '../../domain/repository/auth_repository.dart';
import '../service/supabase_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseService service;

  AuthRepositoryImpl({required this.service});

  @override
  Future<Result<User>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final client = await service.getClient();
      final response = await client.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        final user = User(
          id: response.user!.id,
          email: response.user!.email ?? '',
          name: response.user!.userMetadata?['name'] ?? 'Unknown',
        );
        return Result.success(user);
      }
      return Result.error(ErrorModel('User data is null'));
    } on AuthException catch (error) {
      return Result.error(SupabaseAuthError.fromAuthException(error));
    } catch (error) {
      log('error in data $error');
      return Result.error(ErrorModel(error.toString()));
    }
  }
}

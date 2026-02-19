import '../entity/user.dart' as user_entity;

import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../../core/errors/result.dart';
import '../entity/user.dart';

abstract class AuthenticationRepository {
  Future<Result<void>> register(user_entity.User user, String password);
  Future<Result<User>> signIn({
    required String email,
    required String password,
  });

  Stream<AuthState> get onAuthStateChange;

  Future<String?> get userEmail;

  Future<Result<bool>> resetPasswordForEmail(String email);

  Future<Result<bool>> signInWithGoogle();

  Future<Result<bool>> updatePassword(String password);
}

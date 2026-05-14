import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../../core/errors/result.dart';
import '../entity/user.dart' as user_entity;

abstract class AuthService {
  Future<Result<user_entity.User>> register(user_entity.User user, String password);

  Future<Result<user_entity.User>> signIn({
    required String email,
    required String password,
  });

  Stream<AuthState> get onAuthStateChange;

  Future<String?> get userEmail;

  Future<Result<bool>> resetPasswordForEmail(String email);

  Future<Result<bool>> signInWithGoogle();

  Future<Result<bool>> updatePassword(String password);

  Future<Result<bool>> updateUserInfo(user_entity.User user);

  Future<void> signOut();
}

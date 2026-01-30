import '../entity/user.dart' as user_entity;

import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../../core/errors/result.dart';
import '../../domain/entity/user.dart';

abstract class AuthenticationRepository {
  Future<Result<void>> register(user_entity.User user, String password);
  void signInWithGoogle();
  Future<void> resetPasswordForEmail(String email);

  Stream<AuthState> get onAuthStateChange;

  Future<void> updatePassword(String password);

  Future<Result<User>> signIn({required String email, required String password});
}
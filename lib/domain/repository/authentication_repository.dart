import '../entity/user.dart' as user_entity;

import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthenticationRepository {
  void register(user_entity.User user, String password);
  void signInWithGoogle();
  Future<void> resetPasswordForEmail(String email);

  Stream<AuthState> get onAuthStateChange;

  Future<void> updatePassword(String password);
}
import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthenticationRepository {
  Future<void> resetPasswordForEmail(String email);

  Stream<AuthState> get onAuthStateChange;

  Future<void> updatePassword(String password);
}

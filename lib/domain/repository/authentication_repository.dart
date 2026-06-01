import 'dart:async';

import '../../core/errors/result.dart';
import '../entity/auth_status.dart';
import '../entity/user.dart' as user_entity;
import '../entity/user.dart';

abstract class AuthenticationRepository {
  Future<Result<user_entity.User>> register(user_entity.User user, String password);
  Future<Result<User>> signIn({
    required String email,
    required String password,
  });

  Stream<AuthStatus> get onAuthStatusChange;

  Future<void> refreshAuthStatus();

  Future<String?> get userEmail;

  Future<Result<bool>> resetPasswordForEmail(String email);

  Future<Result<bool>> signInWithGoogle();

  Future<Result<bool>> updatePassword(String password);

  Future<Result<bool>> updateUserInfo(user_entity.User user);

  Future<void> signOut();
}

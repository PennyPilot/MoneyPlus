import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../../core/errors/result.dart';
import '../../domain/entity/user.dart';
import '../../domain/repository/authentication_repository.dart';
import '../../domain/service/auth_service.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthService authService;

  AuthenticationRepositoryImpl({
    required this.authService,
  });

  @override
  Future<Result<User>> register(User user, String password) {
    return authService.register(user, password);
  }

  @override
  Future<Result<bool>> signInWithGoogle() {
    return authService.signInWithGoogle();
  }

  @override
  Stream<AuthState> get onAuthStateChange => authService.onAuthStateChange;

  @override
  Future<Result<bool>> resetPasswordForEmail(String email) {
    return authService.resetPasswordForEmail(email);
  }

  @override
  Future<Result<bool>> updatePassword(String password) {
    return authService.updatePassword(password);
  }

  @override
  Future<Result<bool>> updateUserInfo(User user) {
    return authService.updateUserInfo(user);
  }

  @override
  Future<Result<User>> signIn({
    required String email,
    required String password,
  }) {
    return authService.signIn(email: email, password: password);
  }

  @override
  Future<String?> get userEmail => authService.userEmail;

  @override
  Future<void> signOut() {
    return authService.signOut();
  }
}

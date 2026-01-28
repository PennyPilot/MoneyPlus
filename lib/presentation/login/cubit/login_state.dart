import 'package:flutter/cupertino.dart';

import '../../../core/errors/error_model.dart';
import '../../../domain/entity/user.dart';

enum LoginStatus { initial, loading, success, failure }

@immutable
class LoginState {
  final LoginStatus status;
  final ErrorModel? error;
  final String email;
  final String password;
  final bool isEnabled;
  final User? user;

  const LoginState({
    required this.status,
    this.email = '',
    this.password = '',
    this.isEnabled = false,
    this.error,
    this.user,
  });

  factory LoginState.initial() => const LoginState(status: LoginStatus.initial);

  LoginState copyWith({
    LoginStatus? status,
    String? email,
    String? password,
    bool? isEnabled,
    ErrorModel? error,
    User? user,
  }) {
    return LoginState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      isEnabled: isEnabled ?? this.isEnabled,
      error: error ?? this.error,
      user: user ?? this.user,
    );
  }
}

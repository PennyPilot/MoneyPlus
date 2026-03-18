import 'package:flutter/cupertino.dart';

import '../../../domain/entity/user.dart';

@immutable
sealed class AccountState {
  const AccountState();
}

class AccountInitial extends AccountState {
  const AccountInitial();
}

class AccountLoading extends AccountState {
  final bool isLoading;

  const AccountLoading({required this.isLoading});
}

class AccountLoaded extends AccountState {
  final User user;

  const AccountLoaded({required this.user});

  AccountLoaded copyWith({User? user}) {
    return AccountLoaded(user: user ?? this.user);
  }
}

class AccountError extends AccountState {
  final String errorMessage;

  const AccountError({required this.errorMessage});
}

class LogoutSuccess extends AccountState {
  const LogoutSuccess();
}
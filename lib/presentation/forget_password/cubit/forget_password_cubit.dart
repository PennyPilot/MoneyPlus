import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/domain/repository/authentication_repository.dart';
import 'package:moneyplus/domain/validator/authentication_validator.dart';

import 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final AuthenticationRepository authenticationRepository;
  final AuthenticationValidator validator;
  ForgetPasswordCubit(this.authenticationRepository, this.validator)
    : super(const ForgetPasswordState());

  void onEmailChanged(String email) {
    final isEmailValid = validator.isEmailValid(email);
    emit(state.copyWith(email: email, isEmailValid: isEmailValid));
  }

  Future<void> onClickForgetPassword() async {
    emit(state.copyWith(status: ForgetPasswordStatus.loading));
    try {
      await authenticationRepository.resetPasswordForEmail(state.email);
      emit(state.copyWith(status: ForgetPasswordStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ForgetPasswordStatus.error));
    }
  }
}

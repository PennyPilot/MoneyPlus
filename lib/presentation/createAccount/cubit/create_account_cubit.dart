import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/domain/repository/app_preferences_repository.dart';

import '../../../domain/validator/authentication_validator.dart';
import 'create_account_state.dart';

class CreateAccountCubit extends Cubit<CreateAccountState> {
  final AuthenticationValidator _validator;
  final AppPreferencesRepository _preferencesRepository;

  CreateAccountCubit(this._validator, this._preferencesRepository)
      : super(CreateAccountState());

  Future<void> init() async {
    final progress = await _preferencesRepository.getAccountSetupProgress();
    if (progress != null) {
      final password = progress['password'] as String? ?? state.password;
      emit(state.copyWith(
        name: progress['name'] as String? ?? state.name,
        email: progress['email'] as String? ?? state.email,
        password: password,
      ));
      _updatePasswordValidation(password);
      enable();
    }
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value));
    enable();
  }

  void nameChanged(String value) {
    emit(state.copyWith(name: value));
    enable();
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value));
    _updatePasswordValidation(value);
    enable();
  }

  void _updatePasswordValidation(String password) {
    emit(state.copyWith(
      hasMinLength: _validator.hasMinLength(password),
      hasUppercase: _validator.hasUppercase(password),
      hasSpecialChar: _validator.hasSpecialChar(password),
    ));
  }

  void enable() {
    if (_validator.isEmailValid(state.email) &&
        state.name.isNotEmpty &&
        _validator.isPasswordValid(state.password)) {
      emit(state.copyWith(isEnabled: true));
    } else {
      emit(state.copyWith(isEnabled: false));
    }
  }

  Future<void> submit() async {
    await _preferencesRepository.saveAccountSetupProgress({
      'name': state.name,
      'email': state.email,
      'password': state.password,
      'step': 0,
    });
    emit(state.copyWith(isRegisterSuccess: true));
  }

  void showSnackBar(String message) {
    emit(state.copyWith(isLoading: false, errorMessage: message));
    emit(state.copyWith(errorMessage: null));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }
}

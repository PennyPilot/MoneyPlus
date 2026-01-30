import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/domain/repository/authentication_repository.dart';

import '../../../domain/validator/authentication_validator.dart';
import 'create_account_state.dart';

class CreateAccountCubit extends Cubit<CreateAccountState> {
  final AuthenticationValidator _validator;
  final AuthenticationRepository _authenticationRepository;

  CreateAccountCubit(this._validator, this._authenticationRepository)
    : super(CreateAccountState());

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
    if (_validator.isPasswordValid(state.password)) {
      enable();
    } else {
      emit(state.copyWith(isEnabled: false));
    }
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
    emit(state.copyWith(isLoading: true));
    final result = await _authenticationRepository.register(
      state.toEntity(),
      state.password,
    );
    result.when(
      onSuccess: (user) {
        emit(state.copyWith(isLoading: false));
      },
      onError: (error){
        emit(state.copyWith(isLoading: false));
        emit(state.copyWith(errorMessage: error.message));
        emit(state.copyWith(errorMessage: null));
      },
    );
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }
}

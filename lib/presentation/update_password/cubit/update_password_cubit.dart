import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/domain/repository/authentication_repository.dart';
import 'package:moneyplus/domain/validator/authentication_validator.dart';

import 'update_password_state.dart';

class UpdatePasswordCubit extends Cubit<UpdatePasswordState> {
  final AuthenticationRepository authenticationRepository;
  final AuthenticationValidator validator;

  UpdatePasswordCubit({
    required this.authenticationRepository,
    required this.validator,
  }) : super(const UpdatePasswordState());

  void onPasswordChanged(String password) {
    emit(state.copyWith(password: password));
    _checkIsInputsValid();
  }

  void onConfirmPasswordChanged(String confirmPassword) {
    emit(state.copyWith(confirmPassword: confirmPassword));
    _checkIsInputsValid();
  }

  void _checkIsInputsValid() {
    final isPasswordValid = validator.isPasswordValid(state.password);
    final doPasswordsMatch = state.password.isNotEmpty && state.password == state.confirmPassword;
    emit(state.copyWith(isEnabled: isPasswordValid && doPasswordsMatch));
  }

  Future<void> init() async {
    final email = await authenticationRepository.userEmail;
    emit(state.copyWith(email: email, status: UpdatePasswordStatus.initial));
  }

  Future<void> updatePassword() async {
    emit(state.copyWith(status: UpdatePasswordStatus.loading));
    final result = await authenticationRepository.updatePassword(state.password);
    result.when(
      onSuccess: (value) async {
        await authenticationRepository.signOut();
        emit(state.copyWith(status: UpdatePasswordStatus.success));
      },
      onError: (error) {
        emit(state.copyWith(status: UpdatePasswordStatus.error));
      },
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repository/authentication_repository.dart';
import '../../../domain/validator/authentication_validator.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository authRepository;
  final AuthenticationValidator validator;

  LoginCubit({required this.authRepository, required this.validator})
    : super(LoginState.initial());

  void checkIsInputsValid() {
    final bool isEnabled =
        validator.isEmailValid(state.email) &&
        validator.isPasswordValid(state.password);
    emit(state.copyWith(isEnabled: isEnabled));
  }

  void onEmailChanged(String email) {
    emit(state.copyWith(email: email));
    checkIsInputsValid();
  }

  void onPasswordChanged(String password) {
    emit(state.copyWith(password: password));
    checkIsInputsValid();
  }

  void login() async {
    emit(state.copyWith(status: LoginStatus.loading));

    final result = await authRepository.signIn(
      email: state.email,
      password: state.password,
    );

    result.when(
      onSuccess: (user) {
        emit(state.copyWith(status: LoginStatus.success, user: user));
      },
      onError: (error) {
        emit(state.copyWith(status: LoginStatus.failure, error: error));
      },
    );
  }

  void signInWithGoogle() async {
    emit(state.copyWith(status: LoginStatus.loading));

    final result = await authRepository.signInWithGoogle();

    result.when(
      onSuccess: (success) {
        emit(state.copyWith(status: LoginStatus.success));
      },
      onError: (error) {
        emit(state.copyWith(status: LoginStatus.failure, error: error));
      },
    );
  }
}
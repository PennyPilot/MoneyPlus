import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/domain/repository/app_preferences_repository.dart';
import '../../../domain/entity/auth_status.dart';
import '../../../domain/repository/authentication_repository.dart';
import '../../../domain/validator/authentication_validator.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository authRepository;
  final AuthenticationValidator validator;
  final AppPreferencesRepository preferencesRepository;

  LoginCubit({
    required this.authRepository,
    required this.validator,
    required this.preferencesRepository,
  }) : super(LoginState.initial());

  Future<void> checkAccountSetupHint(bool routeFlag) async {
    final progress = await preferencesRepository.getAccountSetupProgress();

    final currentStatus = await authRepository.onAuthStatusChange.first;
    final isAuthIncomplete = currentStatus == AuthStatus.accountSetupIncomplete;

    final shouldShow = routeFlag || progress != null || isAuthIncomplete;

    emit(state.copyWith(showAccountSetupHint: shouldShow));
  }

  void hideAccountSetupHint() {
    emit(state.copyWith(showAccountSetupHint: false));
  }

  void clearSetupProgress() async {
    await preferencesRepository.clearAccountSetupProgress();
    hideAccountSetupHint();
  }

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
      onSuccess: (success) async {
        await preferencesRepository.clearAccountSetupProgress();
        emit(state.copyWith(
            status: LoginStatus.success, showAccountSetupHint: false));
      },
      onError: (error) {
        emit(state.copyWith(status: LoginStatus.failure, error: error));
      },
    );
  }
}
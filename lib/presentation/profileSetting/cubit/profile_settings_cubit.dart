import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repository/account_repository.dart';
import '../../../domain/repository/authentication_repository.dart';
import '../../../domain/validator/authentication_validator.dart';
import 'profile_settings_state.dart';

class ProfileSettingsCubit extends Cubit<ProfileSettingsState> {
  final AuthenticationValidator _validator;
  final AuthenticationRepository _authenticationRepository;
  final AccountRepository _accountRepository;

  ProfileSettingsCubit(
    this._validator,
    this._authenticationRepository,
    this._accountRepository,
  ) : super(ProfileSettingsState());

  Future<void> initWithData(String name, String email) async {
    emit(state.copyWith(name: name, email: email));
    enable();
  }

  Future<void> loadUserInfo() async {
    emit(state.copyWith(isLoading: true));

    final result = await _accountRepository.getCurrentUser();

    result.when(
      onSuccess: (user) {
        emit(
          state.copyWith(email: user.email, name: user.name, isLoading: false),
        );
      },
      onError: (error) {
        showErrorSnackBar(error.message);
      },
    );
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value));
    enable();
  }

  void nameChanged(String value) {
    emit(state.copyWith(name: value));
    enable();
  }

  void enable() {
    if (_validator.isEmailValid(state.email) && state.name.isNotEmpty) {
      emit(state.copyWith(isEnabled: true));
    } else {
      emit(state.copyWith(isEnabled: false));
    }
  }

  Future<void> save() async {
    emit(state.copyWith(isLoading: true));
    final result = await _authenticationRepository.updateUserInfo(
      state.toEntity(),
    );
    result.when(
      onSuccess: (user) {
        emit(state.copyWith(isLoading: false, isSavedSuccess: true));
      },
      onError: (error) {
        showErrorSnackBar(error.message);
      },
    );
  }

  void showErrorSnackBar(String message) {
    emit(state.copyWith(isLoading: false, errorMessage: message));
    emit(state.copyWith(errorMessage: null));
  }
}

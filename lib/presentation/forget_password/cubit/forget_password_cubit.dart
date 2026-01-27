import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/domain/repository/authentication_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final AuthenticationRepository authenticationRepository;
  late final StreamSubscription<AuthState> _authSubscription;

  ForgetPasswordCubit(this.authenticationRepository)
    : super(ForgetPasswordState.initial()) {
    _authSubscription = authenticationRepository.onAuthStateChange.listen((
      data,
    ) {
      if (data.event == AuthChangeEvent.passwordRecovery) {
        emit(state.copyWith(status: ForgetPasswordStatus.passwordRecovery));
      }
    });
  }

  Future<void> onClickForgetPassword(String email) async {
    emit(state.copyWith(status: ForgetPasswordStatus.loading));
    try {
      await authenticationRepository.resetPasswordForEmail(email);
      emit(state.copyWith(status: ForgetPasswordStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ForgetPasswordStatus.error));
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}

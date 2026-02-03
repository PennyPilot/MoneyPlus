import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/domain/repository/authentication_repository.dart';

import 'update_password_state.dart';

class UpdatePasswordCubit extends Cubit<UpdatePasswordState> {
  final AuthenticationRepository authenticationRepository;

  UpdatePasswordCubit(this.authenticationRepository)
    : super(const UpdatePasswordState());

  Future<void> init() async {
    final email = await authenticationRepository.userEmail;
    emit(state.copyWith(email: email, status: UpdatePasswordStatus.initial));
  }

  Future<void> updatePassword(String password) async {
    emit(state.copyWith(status: UpdatePasswordStatus.loading));
    final result = await authenticationRepository.updatePassword(password);
    result.when(
      onSuccess: (value) {
        emit(state.copyWith(status: UpdatePasswordStatus.success));
      },
      onError: (error) {
        emit(state.copyWith(status: UpdatePasswordStatus.error));
      },
    );
  }
}

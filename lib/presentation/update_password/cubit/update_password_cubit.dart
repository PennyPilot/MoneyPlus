import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/domain/repository/authentication_repository.dart';

import 'update_password_state.dart';

class UpdatePasswordCubit extends Cubit<UpdatePasswordState> {
  final AuthenticationRepository authenticationRepository;

  UpdatePasswordCubit(this.authenticationRepository) : super(const UpdatePasswordState());

  Future<void> updatePassword(String password) async {
    emit(state.copyWith(status: UpdatePasswordStatus.loading));
    try {
      await authenticationRepository.updatePassword(password);
      emit(state.copyWith(status: UpdatePasswordStatus.success));
    } catch (e) {
      emit(state.copyWith(status: UpdatePasswordStatus.error));
    }
  }
}

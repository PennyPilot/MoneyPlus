import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repository/account_repository.dart';
import 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final AccountRepository _accountRepository;

  AccountCubit(this._accountRepository)
      : super(const AccountLoading(isLoading: true));

  void loadUserInfo() {
    emit(const AccountLoading(isLoading: true));

    _accountRepository.getCurrentUser().then((user) {
      emit(AccountLoaded(user: user));
    }).catchError((error) {
      emit(AccountError(errorMessage: error.toString()));
    });
  }
}

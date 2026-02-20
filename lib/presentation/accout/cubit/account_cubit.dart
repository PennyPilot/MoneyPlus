import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repository/account_repository.dart';
import 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final AccountRepository _accountRepository;

  AccountCubit(this._accountRepository)
      : super(const AccountLoading(isLoading: true));

  Future<void> loadUserInfo() async {
    try {
      emit(const AccountLoading(isLoading: true));
      final user = await _accountRepository.getCurrentUser();
      emit(AccountLoaded(user: user,));
    } catch (e) {
      emit(AccountError(errorMessage: e.toString()));
    }
  }

}

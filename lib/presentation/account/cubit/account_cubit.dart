import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/domain/repository/authentication_repository.dart';

import '../../../domain/repository/account_repository.dart';
import 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final AccountRepository _accountRepository;
  final AuthenticationRepository _authRepository;

  AccountCubit(this._accountRepository, this._authRepository) : super(const AccountInitial());

  Future<void> loadUserInfo() async {
    emit(const AccountLoading(isLoading: true));

    final result = await _accountRepository.getCurrentUser();

    result.when(
      onSuccess: (user) {
        emit(AccountLoaded(user: user));
      },
      onError: (error) {
        emit(AccountError(errorMessage: error.toString()));
      },
    );
  }

  Future<void> logout() async {
    emit(const AccountLoading(isLoading: true));
    try {
      await _authRepository.signOut();
      emit(const LogoutSuccess());
    } catch (e) {
      emit(AccountError(errorMessage: e.toString()));
    }
  }

  Future<void> updateCurrency(int currencyId) async {
    emit(const AccountLoading(isLoading: true));
    try {
      await _accountRepository.updateCurrency(currencyId);
      await loadUserInfo();
    } catch (e) {
      emit(AccountError(errorMessage: e.toString()));
    }
  }
}

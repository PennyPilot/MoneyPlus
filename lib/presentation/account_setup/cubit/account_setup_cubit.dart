import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repository/account_repository.dart';
import 'account_setup_state.dart';

class AccountSetupCubit extends Cubit<AccountSetupState> {
  final AccountRepository _accountSetupRepository;

  AccountSetupCubit(this._accountSetupRepository) : super(AccountSetupState());

  Future<void> fetchCurrencies() async {
    try {
      final currencies = await _accountSetupRepository.getCurrencies();
      emit(state.copyWith(currencies: currencies, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }


  bool _accountSetUpStep1ValidationInput() {
    return state.currency.isNotEmpty && state.salary.isNotEmpty && state.salaryDay.isNotEmpty;
  }

  bool _accountSetUpStep2ValidationInput() {
    return state.currentBalance.isNotEmpty;
  }

  void onSalaryChanged(String salary){
    emit(state.copyWith(salary: salary));
    _updateButtonEnabledState();
  }

  void onCurrencyChanged(String currency){
    emit(state.copyWith(currency: currency));
    _updateButtonEnabledState();
  }

  void onSalaryDayChanged(String salaryDay){
    emit(state.copyWith(salaryDay: salaryDay));
    _updateButtonEnabledState();
  }

  void onCurrentBalanceChanged(String currentBalance) {
    emit(state.copyWith(currentBalance: currentBalance));
    _updateButtonEnabledState();
  }

  void _updateButtonEnabledState() {

    bool isButtonEnable = switch (state.accountStep) {
      AccountStep.step1 => _accountSetUpStep1ValidationInput(),
      AccountStep.step2 => _accountSetUpStep2ValidationInput(),
      AccountStep.step3 => false,
    };
    emit(state.copyWith(isButtonEnabled: isButtonEnable));
  }

  void onNextStep() {
    switch (state.accountStep) {
      case AccountStep.step1:
        emit(state.copyWith(accountStep: AccountStep.step2));
        _updateButtonEnabledState();
        break;
      case AccountStep.step2:
        emit(state.copyWith(accountStep: AccountStep.step3));
        _updateButtonEnabledState();
        break;
        case AccountStep.step3:
          // submit account setup date
        emit(state.copyWith(navigateToHome: true));
        break;
    }
  }
}

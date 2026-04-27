import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/domain/entity/currency.dart';
import 'package:moneyplus/domain/repository/authentication_repository.dart';
import 'package:moneyplus/domain/entity/user.dart' as entity;

import '../../../domain/repository/account_repository.dart';
import 'account_setup_state.dart';

class AccountSetupCubit extends Cubit<AccountSetupState> {
  final AccountRepository _accountSetupRepository;
  final AuthenticationRepository _authRepository;

  AccountSetupCubit(
    this._accountSetupRepository,
    this._authRepository,
  ) : super(AccountSetupState());

  Future<void> init() async {
    await fetchCurrencies();
  }

  void initUserData({
    required String name,
    required String email,
    required String password,
  }) {
    emit(state.copyWith(
      name: name,
      email: email,
      password: password,
    ));
  }

  Future<void> fetchCurrencies() async {
    try {
      final currencies = await _accountSetupRepository.getCurrencies();
      emit(state.copyWith(
        currencies: currencies,
        filteredCurrencies: currencies,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void onSearchChanged(String query) {
    final filtered = state.currencies
        .where((currency) =>
            currency.name.toLowerCase().contains(query.toLowerCase()) ||
            currency.abbreviation.toLowerCase().contains(query.toLowerCase()))
        .toList();

    emit(state.copyWith(
      query: query,
      filteredCurrencies: filtered,
    ));
  }

  bool _accountSetUpStep1ValidationInput() {
    return state.selectedCurrency != null && state.salary.isNotEmpty && state.salaryDay.isNotEmpty;
  }

  bool _accountSetUpStep2ValidationInput() {
    return state.currentBalance.isNotEmpty;
  }

  bool _accountSetUpStep3ValidationInput() {
    return state.categories.isNotEmpty;
  }

  void onCategoryChanged(List<String> categories) {
    emit(state.copyWith(categories: categories));
    _updateButtonEnabledState();
  }

  void onSalaryChanged(String salary) {
    emit(state.copyWith(salary: salary));
    _updateButtonEnabledState();
  }

  void onCurrencyChanged(Currency currency) {
    emit(state.copyWith(selectedCurrency: currency));
    _updateButtonEnabledState();
  }

  void onSalaryDayChanged(String salaryDay) {
    emit(state.copyWith(salaryDay: salaryDay));
    _updateButtonEnabledState();
  }

  void onCurrentBalanceChanged(String currentBalance) {
    emit(state.copyWith(currentBalance: currentBalance));
    _updateButtonEnabledState();
  }

  void _updateButtonEnabledState() {
    bool isButtonEnable = switch (state.accountStep) {
      AccountSetupStep.step1 => _accountSetUpStep1ValidationInput(),
      AccountSetupStep.step2 => _accountSetUpStep2ValidationInput(),
      AccountSetupStep.step3 => _accountSetUpStep3ValidationInput(),
    };
    emit(state.copyWith(isButtonEnabled: isButtonEnable));
  }

  void onNextStep() {
    switch (state.accountStep) {
      case AccountSetupStep.step1:
        emit(state.copyWith(accountStep: AccountSetupStep.step2));
        _updateButtonEnabledState();
        break;
      case AccountSetupStep.step2:
        emit(state.copyWith(accountStep: AccountSetupStep.step3));
        _updateButtonEnabledState();
        break;
      case AccountSetupStep.step3:
        _updateButtonEnabledState();
        submitAccountSetupData();
        break;
    }
  }

  void onPreviousStep() {
    switch (state.accountStep) {
      case AccountSetupStep.step1:
        break;
      case AccountSetupStep.step2:
        emit(state.copyWith(accountStep: AccountSetupStep.step1));
        _updateButtonEnabledState();
        break;
      case AccountSetupStep.step3:
        emit(state.copyWith(accountStep: AccountSetupStep.step2));
        _updateButtonEnabledState();
        break;
    }
  }

  void toggleCategory(String category) {
    final List<String> updatedCategories = List.from(state.categories);
    if (updatedCategories.contains(category)) {
      updatedCategories.remove(category);
    } else {
      updatedCategories.add(category);
    }
    emit(state.copyWith(categories: updatedCategories));
    _updateButtonEnabledState();
  }

  Future<void> submitAccountSetupData() async {
    emit(state.copyWith(isLoading: true));
    try {
      final registerResult = await _authRepository.register(
        entity.User(
          id: '',
          email: state.email,
          name: state.name,
        ),
        state.password,
      );

      await registerResult.when(
        onSuccess: (user) async {
          final salary = double.tryParse(state.salary) ?? 0.0;
          final salaryDay = int.tryParse(state.salaryDay) ?? 1;
          final currentBalance = double.tryParse(state.currentBalance) ?? 0.0;

          await _accountSetupRepository.completeAccountSetup(
            userId: user.id,
            salary: salary,
            salaryDay: salaryDay,
            currencyId: state.selectedCurrency?.id ?? 0,
            initialBalance: currentBalance,
            categories: state.categories,
          );

          emit(state.copyWith(navigateToHome: true, isLoading: false));
        },
        onError: (error) {
          emit(state.copyWith(isLoading: false, errorMessage: error.message));
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}

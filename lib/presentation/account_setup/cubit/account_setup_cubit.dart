import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/domain/entity/currency.dart';
import 'package:moneyplus/domain/repository/app_preferences_repository.dart';
import 'package:moneyplus/domain/repository/authentication_repository.dart';
import 'package:moneyplus/domain/entity/user.dart' as entity;

import '../../../domain/repository/account_repository.dart';
import 'account_setup_state.dart';

class AccountSetupCubit extends Cubit<AccountSetupState> {
  final AccountRepository _accountSetupRepository;
  final AuthenticationRepository _authRepository;
  final AppPreferencesRepository _preferencesRepository;

  AccountSetupCubit(
    this._accountSetupRepository,
    this._authRepository,
    this._preferencesRepository,
  ) : super(AccountSetupState());

  Future<void> init() async {
    await fetchCurrencies();
    await _loadSavedProgress();
  }

  Future<void> _loadSavedProgress() async {
    final progress = await _preferencesRepository.getAccountSetupProgress();
    if (progress != null) {
      int stepIndex = progress['step'] as int? ?? 0;
      if (stepIndex < 0 || stepIndex >= AccountSetupStep.values.length) {
        stepIndex = 0;
      }
      final savedStep = AccountSetupStep.values[stepIndex];
      
      Currency? selectedCurrency;
      if (progress['currencyId'] != null && state.currencies.isNotEmpty) {
        final currencyId = progress['currencyId'] as int;
        selectedCurrency = state.currencies.firstWhere(
          (c) => c.id == currencyId,
          orElse: () => state.currencies.first,
        );
      }

      emit(state.copyWith(
        name: progress['name'] as String? ?? state.name,
        email: progress['email'] as String? ?? state.email,
        password: progress['password'] as String? ?? state.password,
        salary: progress['salary'] as String? ?? state.salary,
        salaryDay: progress['salaryDay'] as String? ?? state.salaryDay,
        selectedCurrency: selectedCurrency ?? state.selectedCurrency,
        currentBalance: progress['balance'] as String? ?? state.currentBalance,
        categories: (progress['categories'] as List<dynamic>?)?.cast<String>() ?? state.categories,
        accountStep: savedStep,
      ));
      _validate();
    }
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
    _preferencesRepository.saveAccountSetupProgress({
      'name': name,
      'email': email,
      'password': password,
    });
  }

  Future<void> fetchCurrencies() async {
    try {
      final currencies = await _accountSetupRepository.getCurrencies();
      emit(state.copyWith(
        currencies: currencies,
        filteredCurrencies: currencies,
        isLoading: false,
      ));
      final progress = await _preferencesRepository.getAccountSetupProgress();
      if (progress?['currencyId'] != null) {
        final currencyId = progress!['currencyId'] as int;
        final selectedCurrency = currencies.firstWhere(
          (c) => c.id == currencyId,
          orElse: () => state.selectedCurrency ?? currencies.first,
        );
        emit(state.copyWith(selectedCurrency: selectedCurrency));
      }
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

  void onCategoryChanged(List<String> categories) {
    emit(state.copyWith(categories: categories));
    _preferencesRepository.saveAccountSetupProgress({'categories': categories});
    _validate();
  }

  void onSalaryChanged(String salary) {
    emit(state.copyWith(salary: salary));
    _preferencesRepository.saveAccountSetupProgress({'salary': salary});
    _validate();
  }

  void onCurrencyChanged(Currency currency) {
    emit(state.copyWith(selectedCurrency: currency));
    _preferencesRepository.saveAccountSetupProgress({'currencyId': currency.id});
    _validate();
  }

  void onSalaryDayChanged(String salaryDay) {
    emit(state.copyWith(salaryDay: salaryDay));
    _preferencesRepository.saveAccountSetupProgress({'salaryDay': salaryDay});
    _validate();
  }

  void onCurrentBalanceChanged(String currentBalance) {
    emit(state.copyWith(currentBalance: currentBalance));
    _preferencesRepository.saveAccountSetupProgress({'balance': currentBalance});
    _validate();
  }

  void _validate() {
    final salary = double.tryParse(state.salary) ?? 0;
    final salaryDay = int.tryParse(state.salaryDay) ?? 0;

    final bool isSalaryInvalid = state.salary.isNotEmpty && salary > 999000000;
    final bool isSalaryDayInvalid = state.salaryDay.isNotEmpty && (salaryDay < 1 || salaryDay > 28);

    bool isButtonEnable = switch (state.accountStep) {
      AccountSetupStep.step1 => 
        state.selectedCurrency != null &&
        state.salary.isNotEmpty &&
        !isSalaryInvalid &&
        state.salaryDay.isNotEmpty &&
        !isSalaryDayInvalid,
      AccountSetupStep.step2 => state.currentBalance.isNotEmpty,
      AccountSetupStep.step3 => state.categories.isNotEmpty,
    };

    emit(state.copyWith(
      isButtonEnabled: isButtonEnable,
      salaryError: isSalaryInvalid ? "limit_exceeded" : "",
      salaryDayError: isSalaryDayInvalid ? "range_error" : "",
    ));
  }

  void onNextStep() {
    switch (state.accountStep) {
      case AccountSetupStep.step1:
        emit(state.copyWith(accountStep: AccountSetupStep.step2));
        _preferencesRepository.saveAccountSetupProgress({'step': 1});
        _validate();
        break;
      case AccountSetupStep.step2:
        emit(state.copyWith(accountStep: AccountSetupStep.step3));
        _preferencesRepository.saveAccountSetupProgress({'step': 2});
        _validate();
        break;
      case AccountSetupStep.step3:
        _validate();
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
        _preferencesRepository.saveAccountSetupProgress({'step': 0});
        _validate();
        break;
      case AccountSetupStep.step3:
        emit(state.copyWith(accountStep: AccountSetupStep.step2));
        _preferencesRepository.saveAccountSetupProgress({'step': 1});
        _validate();
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
    _preferencesRepository.saveAccountSetupProgress({'categories': updatedCategories});
    _validate();
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

          await _preferencesRepository.clearAccountSetupProgress();
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

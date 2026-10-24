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
        categories: (progress['categories'] as List<dynamic>?)?.cast<String>() ??
            state.categories,
        accountStep: savedStep,
      ));
      _validate();
    }
  }

  void initUserData({
    String? name,
    String? email,
    String? password,
  }) {
    emit(state.copyWith(
      name: name ?? state.name,
      email: email ?? state.email,
      password: password ?? state.password,
    ));
    if (name != null || email != null || password != null) {
      _preferencesRepository.saveAccountSetupProgress({
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (password != null) 'password': password,
      });
    }
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
    _preferencesRepository
        .saveAccountSetupProgress({'balance': currentBalance});
    _validate();
  }

  void _validate() {
    final salary = double.tryParse(state.salary) ?? 0;
    final salaryDay = int.tryParse(state.salaryDay) ?? 0;

    final bool isSalaryInvalid = state.salary.isNotEmpty && salary > 999000000;
    final bool isSalaryDayInvalid =
        state.salaryDay.isNotEmpty && (salaryDay < 1 || salaryDay > 28);

    bool isButtonEnable = switch (state.accountStep) {
      AccountSetupStep.salaryManagement =>
        state.selectedCurrency != null &&
            state.salary.isNotEmpty &&
            !isSalaryInvalid &&
            state.salaryDay.isNotEmpty &&
            !isSalaryDayInvalid,
      AccountSetupStep.currentBalance => state.currentBalance.isNotEmpty,
      AccountSetupStep.categorySelection => state.categories.isNotEmpty,
    };

    emit(state.copyWith(
      isButtonEnabled: isButtonEnable,
      salaryError: isSalaryInvalid ? "limit_exceeded" : "",
      salaryDayError: isSalaryDayInvalid ? "range_error" : "",
    ));
  }

  void onNextStep() {
    switch (state.accountStep) {
      case AccountSetupStep.salaryManagement:
        emit(state.copyWith(accountStep: AccountSetupStep.currentBalance));
        _preferencesRepository.saveAccountSetupProgress({'step': 1});
        _validate();
        break;
      case AccountSetupStep.currentBalance:
        emit(state.copyWith(accountStep: AccountSetupStep.categorySelection));
        _preferencesRepository.saveAccountSetupProgress({'step': 2});
        _validate();
        break;
      case AccountSetupStep.categorySelection:
        _validate();
        submitAccountSetupData();
        break;
    }
  }

  void onPreviousStep() {
    switch (state.accountStep) {
      case AccountSetupStep.salaryManagement:
        break;
      case AccountSetupStep.currentBalance:
        emit(state.copyWith(accountStep: AccountSetupStep.salaryManagement));
        _preferencesRepository.saveAccountSetupProgress({'step': 0});
        _validate();
        break;
      case AccountSetupStep.categorySelection:
        emit(state.copyWith(accountStep: AccountSetupStep.currentBalance));
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
    _preferencesRepository
        .saveAccountSetupProgress({'categories': updatedCategories});
    _validate();
  }

  Future<void> submitAccountSetupData() async {
    emit(state.copyWith(isLoading: true));
    try {
      final userResult = await _accountSetupRepository.getCurrentUser();

      await userResult.when(
        onSuccess: (user) async {
          await _completeSetup(user.id);
        },
        onError: (error) async {
          await _registerAndComplete();
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _registerAndComplete() async {
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
        await _completeSetup(user.id);
      },
      onError: (error) {
        emit(state.copyWith(isLoading: false, errorMessage: error.message));
      },
    );
  }

  Future<void> _completeSetup(String userId) async {
    final salary = double.tryParse(state.salary) ?? 0.0;
    final salaryDay = int.tryParse(state.salaryDay) ?? 1;
    final currentBalance = double.tryParse(state.currentBalance) ?? 0.0;

    await _accountSetupRepository.completeAccountSetup(
      userId: userId,
      salary: salary,
      salaryDay: salaryDay,
      currencyId: state.selectedCurrency?.id ?? 0,
      initialBalance: currentBalance,
      categories: state.categories,
    );

    await _authRepository.refreshAuthStatus();
    await _preferencesRepository.clearAccountSetupProgress();
    emit(state.copyWith(navigateToHome: true, isLoading: false));
  }
}

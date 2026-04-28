import 'package:moneyplus/domain/entity/currency.dart';

enum AccountSetupStep {
  step1,
  step2,
  step3,
}

class AccountSetupState {
  final String name;
  final String email;
  final String password;
  final Currency? selectedCurrency;
  final String salary;
  final String salaryDay;
  final String query;
  final bool isButtonEnabled;
  final List<Currency> currencies;
  final List<Currency> filteredCurrencies;
  final List<String> categories;
  final List<String> suggestions;
  final bool isLoading;
  final String errorMessage;
  final String salaryError;
  final String salaryDayError;
  final AccountSetupStep accountStep;
  final String currentBalance;
  final bool navigateToHome;

  AccountSetupState({
    this.name = "",
    this.email = "",
    this.password = "",
    this.selectedCurrency,
    this.salary = "",
    this.salaryDay = "",
    this.query = "",
    this.isButtonEnabled = false,
    this.currencies = const [],
    this.filteredCurrencies = const [],
    this.categories = const [],
    this.suggestions = const [
      'Food',
      'Transport',
      'Shopping',
      'Health',
      'Education',
      'Gift',
      'Cafe',
      'Work',
      'Home',
      'Travel'
    ],
    this.isLoading = true,
    this.errorMessage = "",
    this.salaryError = "",
    this.salaryDayError = "",
    this.accountStep = AccountSetupStep.step1,
    this.currentBalance = "",
    this.navigateToHome = false,
  });

  AccountSetupState copyWith({
    String? name,
    String? email,
    String? password,
    Currency? selectedCurrency,
    String? salary,
    String? salaryDay,
    String? query,
    bool? isButtonEnabled,
    List<Currency>? currencies,
    List<Currency>? filteredCurrencies,
    List<String>? categories,
    List<String>? suggestions,
    String? errorMessage,
    String? salaryError,
    String? salaryDayError,
    bool? isLoading,
    AccountSetupStep? accountStep,
    String? currentBalance,
    bool? navigateToHome,
  }) {
    return AccountSetupState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      salary: salary ?? this.salary,
      salaryDay: salaryDay ?? this.salaryDay,
      query: query ?? this.query,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
      currencies: currencies ?? this.currencies,
      filteredCurrencies: filteredCurrencies ?? this.filteredCurrencies,
      categories: categories ?? this.categories,
      suggestions: suggestions ?? this.suggestions,
      errorMessage: errorMessage ?? this.errorMessage,
      salaryError: salaryError ?? this.salaryError,
      salaryDayError: salaryDayError ?? this.salaryDayError,
      isLoading: isLoading ?? this.isLoading,
      accountStep: accountStep ?? this.accountStep,
      currentBalance: currentBalance ?? this.currentBalance,
      navigateToHome: navigateToHome ?? this.navigateToHome,
    );
  }
}

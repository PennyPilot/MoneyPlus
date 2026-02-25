
import 'package:moneyplus/domain/entity/currency.dart';

enum AccountSetupStep {
  step1,
  step2,
  step3,
}

class AccountSetupState {
  final String currency;
  final String salary;
  final String salaryDay;
  final String query;
  final bool isButtonEnabled;
  final List<Currency> currencies;
  final List<String> categories;
  final List<String> suggestions;
  final bool isLoading;
  final String errorMessage;
  final AccountSetupStep accountStep;
  final String currentBalance;
  final bool navigateToHome;

  AccountSetupState({
    this.currency = "",
    this.salary = "",
    this.salaryDay = "",
    this.query = "",
    this.isButtonEnabled = false,
    this.currencies = const [],
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
    this.accountStep = AccountSetupStep.step1,
    this.currentBalance = "",
    this.navigateToHome = false,
  });

  AccountSetupState copyWith({
    String? currency,
    String? salary,
    String? salaryDay,
    String? query,
    bool? isButtonEnabled,
    List<Currency>? currencies,
    List<String>? categories,
    List<String>? suggestions,
    String? errorMessage,
    bool? isLoading,
    AccountSetupStep? accountStep,
    String? currentBalance,
    bool? navigateToHome,
  }) {
    return AccountSetupState(
      currency: currency ?? this.currency,
      salary: salary ?? this.salary,
      salaryDay: salaryDay ?? this.salaryDay,
      query: query ?? this.query,
      isButtonEnabled: isButtonEnabled?? this.isButtonEnabled,
      currencies: currencies?? this.currencies,
      errorMessage: errorMessage?? this.errorMessage,
      isLoading: isLoading?? this.isLoading,
      accountStep: accountStep?? this.accountStep,
      currentBalance: currentBalance?? this.currentBalance,
      navigateToHome: navigateToHome?? this.navigateToHome,
    );
  }
}

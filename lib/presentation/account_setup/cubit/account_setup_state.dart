
import 'package:moneyplus/domain/entity/currency.dart';

class AccountSetupState {
  final String currency;
  final double salary;
  final int salaryDay;
  final String query;
  final bool isButtonEnabled;
  final List<Currency> currencies;
  final bool isLoading;
  final String errorMessage;

  AccountSetupState({
    this.currency = "",
    this.salary = 0.0,
    this.salaryDay = 0,
    this.query = "",
    this.isButtonEnabled = false,
    this.currencies = const [],
    this.isLoading = true,
    this.errorMessage = "",
  });

  AccountSetupState copyWith({
    String? currency,
    double? salary,
    int? salaryDay,
    String? query,
    bool? isButtonEnabled,
    List<Currency>? currencies,
    String? errorMessage,
    bool? isLoading,
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
    );
  }
}

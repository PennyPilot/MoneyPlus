import 'dart:ffi';

class AccountSetupState {
  final String currency;
  final Double salary;
  final int salaryDay;
  final String query;
  final bool isButtonEnabled;

  AccountSetupState._({
    required this.currency,
    required this.salary,
    required this.salaryDay,
    required this.query,
    required this.isButtonEnabled,
  });

  AccountSetupState copyWith(
    String? currency,
    Double? salary,
    int? salaryDay,
    String? query,
    bool? isButtonEnabled,
  ) {
    return AccountSetupState._(
      currency: currency ?? this.currency,
      salary: salary ?? this.salary,
      salaryDay: salaryDay ?? this.salaryDay,
      query: query ?? this.query,
      isButtonEnabled: isButtonEnabled?? this.isButtonEnabled,
    );
  }
}

part of 'salary_settings_cubit.dart';

@immutable
sealed class SalarySettingsState {}

final class SalarySettingsLoading extends SalarySettingsState {}

final class SalarySettingsLoaded extends SalarySettingsState {
  final String salary;
  final String salaryDay;
  final bool isSaveButtonEnabled;

  SalarySettingsLoaded({
    required this.salary,
    required this.salaryDay,
    required this.isSaveButtonEnabled,
  });

  SalarySettingsLoaded copyWith({
    String? salary,
    String? salaryDay,
    bool? isButtonEnabled,
  }) {
    return SalarySettingsLoaded(
      salary: salary ?? this.salary,
      salaryDay: salaryDay ?? this.salaryDay,
      isSaveButtonEnabled: isButtonEnabled ?? this.isSaveButtonEnabled,
    );
  }
}

final class SalarySettingsError extends SalarySettingsState {
  final SalarySettingsFailure failure;

  SalarySettingsError({required this.failure});
}

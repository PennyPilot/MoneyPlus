part of 'salary_settings_cubit.dart';

@immutable
sealed class SalarySettingsState {}

final class EditSalaryLoading extends SalarySettingsState {}

final class EditSalaryLoaded extends SalarySettingsState {
  final String salary;
  final String salaryDay;
  final bool isButtonEnabled;

  EditSalaryLoaded({
    required this.salary,
    required this.salaryDay,
    required this.isButtonEnabled,
  });

  EditSalaryLoaded copyWith({
    String? salary,
    String? salaryDay,
    bool? isButtonEnabled,
  }) {
    return EditSalaryLoaded(
      salary: salary ?? this.salary,
      salaryDay: salaryDay ?? this.salaryDay,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
    );
  }
}

final class EditSalaryError extends SalarySettingsState {
  final String errorMessage;

  EditSalaryError(this.errorMessage);
}

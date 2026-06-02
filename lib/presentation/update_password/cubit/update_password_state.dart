enum UpdatePasswordStatus { initial, loading, success, error }

class UpdatePasswordState {
  final UpdatePasswordStatus status;
  final String? email;
  final String password;
  final String confirmPassword;
  final bool isEnabled;

  // Password Validation Flags
  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasSpecialChar;

  const UpdatePasswordState({
    this.status = UpdatePasswordStatus.initial,
    this.email,
    this.password = '',
    this.confirmPassword = '',
    this.isEnabled = false,
    this.hasMinLength = false,
    this.hasUppercase = false,
    this.hasSpecialChar = false,
  });

  UpdatePasswordState copyWith({
    UpdatePasswordStatus? status,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isEnabled,
    bool? hasMinLength,
    bool? hasUppercase,
    bool? hasSpecialChar,
  }) {
    return UpdatePasswordState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isEnabled: isEnabled ?? this.isEnabled,
      hasMinLength: hasMinLength ?? this.hasMinLength,
      hasUppercase: hasUppercase ?? this.hasUppercase,
      hasSpecialChar: hasSpecialChar ?? this.hasSpecialChar,
    );
  }
}

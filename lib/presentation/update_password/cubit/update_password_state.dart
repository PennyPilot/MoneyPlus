enum UpdatePasswordStatus { initial, loading, success, error }

class UpdatePasswordState {
  final UpdatePasswordStatus status;
  final String? email;
  final String password;
  final String confirmPassword;
  final bool isEnabled;

  const UpdatePasswordState({
    this.status = UpdatePasswordStatus.initial,
    this.email,
    this.password = '',
    this.confirmPassword = '',
    this.isEnabled = false,
  });

  UpdatePasswordState copyWith({
    UpdatePasswordStatus? status,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isEnabled,
  }) {
    return UpdatePasswordState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

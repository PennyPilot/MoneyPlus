enum ForgetPasswordStatus { initial, loading, success, error, passwordRecovery }

class ForgetPasswordState {
  const ForgetPasswordState({
    this.status = ForgetPasswordStatus.initial,
    this.email = '',
    this.isEmailValid = false,
  });

  final ForgetPasswordStatus status;
  final String email;
  final bool isEmailValid;

  ForgetPasswordState copyWith({
    ForgetPasswordStatus? status,
    String? email,
    bool? isEmailValid,
  }) {
    return ForgetPasswordState(
      status: status ?? this.status,
      email: email ?? this.email,
      isEmailValid: isEmailValid ?? this.isEmailValid,
    );
  }
}

enum ForgetPasswordStatus { initial, loading, success, error, passwordRecovery }

class ForgetPasswordState {
  const ForgetPasswordState({
    this.status = ForgetPasswordStatus.initial,
  });

  final ForgetPasswordStatus status;

  ForgetPasswordState copyWith({
    ForgetPasswordStatus? status,
  }) {
    return ForgetPasswordState(
      status: status ?? this.status,
    );
  }

  factory ForgetPasswordState.initial() => const ForgetPasswordState();
}

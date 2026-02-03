enum UpdatePasswordStatus { initial, loading, success, error }

class UpdatePasswordState {
  final UpdatePasswordStatus status;
  final String? email;

  const UpdatePasswordState({
    this.status = UpdatePasswordStatus.initial,
    this.email,
  });

  UpdatePasswordState copyWith({
    UpdatePasswordStatus? status,
    String? email,
  }) {
    return UpdatePasswordState(
      status: status ?? this.status,
      email: email ?? this.email,
    );
  }
}

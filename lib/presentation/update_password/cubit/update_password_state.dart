enum UpdatePasswordStatus { initial, loading, success, error }

class UpdatePasswordState {
  final UpdatePasswordStatus status;

  const UpdatePasswordState({this.status = UpdatePasswordStatus.initial});

  UpdatePasswordState copyWith({UpdatePasswordStatus? status}) {
    return UpdatePasswordState(status: status ?? this.status);
  }
}

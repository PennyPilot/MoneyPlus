import '../../../domain/entity/user.dart';

class ProfileSettingsState {
  final String email;
  final String name;
  final bool isLoading;
  final bool isEnabled;
  final bool isSavedSuccess;
  final String? errorMessage;

  const ProfileSettingsState({
    this.email = "",
    this.name = "",
    this.isLoading = false,
    this.isEnabled = false,
    this.isSavedSuccess = false,
    this.errorMessage,
  });

  ProfileSettingsState copyWith({
    String? email,
    String? name,
    bool? isLoading,
    bool? isEnabled,
    String? errorMessage,
    bool?  isSavedSuccess,
  }) {
    return ProfileSettingsState(
      email: email ?? this.email,
      name: name ?? this.name,
      isLoading: isLoading ?? this.isLoading,
      isEnabled: isEnabled ?? this.isEnabled,
      errorMessage: errorMessage ?? this.errorMessage,
      isSavedSuccess: isSavedSuccess ?? this.isSavedSuccess,
    );
  }

  User toEntity() {
    return User(id: "", email: email, name: name);
  }
}

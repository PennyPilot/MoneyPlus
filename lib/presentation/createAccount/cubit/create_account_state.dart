import '../../../domain/entity/user.dart';

class CreateAccountState {
  final String email;
  final String name;
  final String password;
  final bool isLoading;
  final bool isEnabled;
  final bool isPasswordVisible;

  const CreateAccountState({
    this.email = "",
    this.name = "",
    this.password = "",
    this.isLoading = false,
    this.isEnabled = false,
    this.isPasswordVisible = false,
  });

  CreateAccountState copyWith({
    String? email,
    String? name,
    String? password,
    bool? isLoading,
    bool? isEnabled,
    bool? showPasswordRequirements,
    bool? isPasswordVisible,
  }) {
    return CreateAccountState(
      email: email ?? this.email,
      name: name ?? this.name,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      isEnabled: isEnabled ?? this.isEnabled,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }

  User toEntity() {
    return User(
      id: 0,
      email: email,
      username: name,
    );
  }
}

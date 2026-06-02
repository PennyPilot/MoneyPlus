class AuthenticationValidator {
  bool isEmailValid(String email) {
    return email.trim().isNotEmpty &&
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
            .hasMatch(email);
  }

  bool isPasswordValid(String password) {
    return hasMinLength(password) &&
        hasUppercase(password) &&
        hasSpecialChar(password);
  }

  bool hasMinLength(String password) => password.length >= 8;
  bool hasUppercase(String password) => password.contains(RegExp(r'[A-Z]'));
  bool hasSpecialChar(String password) =>
      password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
}

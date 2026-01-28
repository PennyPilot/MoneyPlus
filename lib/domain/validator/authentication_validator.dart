class AuthenticationValidator {
  bool isEmailValid(String email) {
    return email.trim().isNotEmpty && RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  bool isPasswordValid(String password) {
    return password.trim().isNotEmpty &&
        password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }
}

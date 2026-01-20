import '../entity/user.dart';

abstract class AuthenticationRepository {
  void register(User user, String password);
}
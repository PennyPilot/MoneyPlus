import '../../core/errors/result.dart';
import '../entity/user.dart';

abstract class AuthRepository {
  Future<Result<User>> signIn({required String email, required String password});
}

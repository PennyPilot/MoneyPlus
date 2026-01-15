import 'package:get_it/get_it.dart';

import '../data/repository/authentication_repository.dart';
import '../domain/repository/authentication_repository.dart';
import '../presentation/home/cubit/home_cubit.dart';
import '../presentation/login/cubit/login_cubit.dart';

final getIt = GetIt.instance;

Future<void> initDI() async {
  getIt.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImp(),
  );

  getIt.registerFactory<LoginCubit>(() => LoginCubit());
  getIt.registerFactory<HomeCubit>(() => HomeCubit());
}

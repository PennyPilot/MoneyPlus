import 'package:get_it/get_it.dart';

import '../data/repository/authentication_repository.dart';
import '../data/service/app_secrets_provider.dart';
import '../data/service/supabase_service.dart';
import '../domain/repository/authentication_repository.dart';
import '../domain/validator/authentication_validator.dart';
import '../presentation/createAccount/cubit/create_account_cubit.dart';
import '../presentation/home/cubit/home_cubit.dart';
import '../presentation/login/cubit/login_cubit.dart';

final getIt = GetIt.instance;

void initDI() {
  getIt.registerLazySingleton<AppSecretsProvider>(() => AppSecretsProvider());
  getIt.registerLazySingleton<SupabaseService>(
    () => SupabaseService(appSecretsProvider: getIt<AppSecretsProvider>()),
  );
  getIt.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(getIt<SupabaseService>()),
  );

  getIt.registerFactory<LoginCubit>(() => LoginCubit());
  getIt.registerFactory<HomeCubit>(() => HomeCubit());
  getIt.registerFactory<AuthenticationValidator>(
    () => AuthenticationValidator(),
  );
  getIt.registerFactory<CreateAccountCubit>(
    () => CreateAccountCubit(
      getIt<AuthenticationValidator>(),
      getIt<AuthenticationRepository>(),
    ),
  );
}

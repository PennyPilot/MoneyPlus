import 'package:get_it/get_it.dart';
import 'package:moneyplus/presentation/account_setup/cubit/account_setup_cubit.dart';

import '../data/repository/account_repository.dart';
import '../data/repository/authentication_repository.dart';
import '../data/service/app_secrets_provider.dart';
import '../data/service/supabase_service.dart';
import '../domain/repository/account_repository.dart';
import '../domain/repository/authentication_repository.dart';
import '../domain/validator/authentication_validator.dart';
import '../presentation/home/cubit/home_cubit.dart';
import '../presentation/login/cubit/login_cubit.dart';

final getIt = GetIt.instance;

void initDI() {
  getIt.registerLazySingleton<AppSecretsProvider>(() => AppSecretsProvider());
  getIt.registerLazySingleton<SupabaseService>(
    () => SupabaseService(appSecretsProvider: getIt<AppSecretsProvider>()),
  );

  getIt.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(
      supabaseService: getIt<SupabaseService>(),
      appSecrets: getIt<AppSecretsProvider>(),
    ),
  );
  getIt.registerLazySingleton<AuthenticationValidator>(
    () => AuthenticationValidator(),
  );

  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(
      authRepository: getIt<AuthenticationRepository>(),
      validator: getIt<AuthenticationValidator>(),
    ),
  );

  getIt.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(supabaseService: getIt<SupabaseService>()
    )
  );

  getIt.registerLazySingleton<AccountSetupCubit>(() => AccountSetupCubit(getIt<AccountRepository>()));

  getIt.registerFactory<HomeCubit>(() => HomeCubit());
}

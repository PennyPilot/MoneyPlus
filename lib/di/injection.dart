import 'package:get_it/get_it.dart';

import '../data/remote/auth_supabase_data_source_impl.dart';
import '../data/repository/auth_repository_impl.dart';
import '../data/repository/data_source/auth_supabase_data_source.dart';
import '../data/service/app_secrets_provider.dart';
import '../data/service/supabase_service.dart';
import '../domain/repository/auth_repository.dart';
import '../domain/validator/authentication_validator.dart';
import '../presentation/home/cubit/home_cubit.dart';
import '../presentation/login/cubit/login_cubit.dart';

final getIt = GetIt.instance;

void initDI() {
  getIt.registerLazySingleton<AppSecretsProvider>(() => AppSecretsProvider());
  getIt.registerLazySingleton<SupabaseService>(
    () => SupabaseService(appSecretsProvider: getIt<AppSecretsProvider>()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(service: getIt()),
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
      authRepository: getIt<AuthRepository>(),
      validator: getIt<AuthenticationValidator>(),
    ),
  );

  getIt.registerFactory<LoginCubit>(() => LoginCubit());
  getIt.registerFactory<HomeCubit>(() => HomeCubit());
}

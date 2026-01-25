import 'package:get_it/get_it.dart';

import '../data/repository/authentication_repository.dart';
import '../data/repository/transaction_repository_stub.dart';
import '../data/service/app_secrets_provider.dart';
import '../data/service/supabase_service.dart';
import '../domain/repository/authentication_repository.dart';
import '../domain/repository/transaction_repository.dart';
import '../presentation/home/cubit/home_cubit.dart';
import '../presentation/income/cubit/add_income_cubit.dart';
import '../presentation/login/cubit/login_cubit.dart';

final getIt = GetIt.instance;

void initDI() {
  getIt.registerLazySingleton<AppSecretsProvider>(() => AppSecretsProvider());
  getIt.registerLazySingleton<SupabaseService>(
    () => SupabaseService(appSecretsProvider: getIt<AppSecretsProvider>()),
  );
  
  getIt.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImp(),
  );
  
  getIt.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryStub(),
  );

  getIt.registerFactory<LoginCubit>(() => LoginCubit());
  getIt.registerFactory<HomeCubit>(() => HomeCubit());
  getIt.registerFactory<AddIncomeCubit>(
    () => AddIncomeCubit(repository: getIt<TransactionRepository>()),
  );
}

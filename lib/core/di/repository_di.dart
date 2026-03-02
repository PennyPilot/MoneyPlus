import 'package:moneyplus/domain/repository/app_preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repository/account_repository.dart';
import '../../data/repository/app_preferences_repository_impl.dart';
import '../../data/repository/authentication_repository.dart';
import '../../data/repository/statistics_repository_impl.dart';
import '../../data/repository/transaction_repository.dart';
import '../../data/repository/user_money_repository.dart';
import '../../domain/repository/account_repository.dart';
import '../../domain/repository/authentication_repository.dart';
import '../../domain/repository/statistics_repository.dart';
import '../../domain/repository/transaction_repository.dart';
import '../../domain/repository/user_money_repository.dart';
import '../service/supabase_service.dart';
import 'injection.dart';

void initRepositoryDI() {
  getIt.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(
      supabaseService: getIt<SupabaseService>(),
      appSecrets: getIt(),
    ),
  );
  getIt.registerLazySingleton<UserMoneyRepository>(
    () => UserRepositoryImpl(service: getIt<SupabaseService>()),
  );
  getIt.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(supabaseService: getIt<SupabaseService>()),
  );
  getIt.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(service: getIt<SupabaseService>()),
  );
  getIt.registerLazySingleton<StatisticsRepository>(
    () => StatisticsRepositoryImpl(supabaseService: getIt<SupabaseService>()),
  );
  getIt.registerLazySingleton<AppPreferencesRepository>(
        () => AppPreferencesRepositoryImpl(sharedPreferences: getIt<SharedPreferences>()),
  );
}

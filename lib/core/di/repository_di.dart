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
import '../../domain/repository/category_repository.dart';
import '../../data/repository/category_repository_impl.dart';
import '../../domain/service/account_service.dart';
import '../../domain/service/auth_service.dart';
import '../../domain/service/category_service.dart';
import '../../domain/service/statistics_service.dart';
import '../../domain/service/transaction_service.dart';
import '../../domain/service/user_money_service.dart';
import '../service/supabase_service.dart';
import 'injection.dart';

void initRepositoryDI() {
  getIt.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(
      authService: getIt<AuthService>(),
    ),
  );
  getIt.registerLazySingleton<UserMoneyRepository>(
    () => UserRepositoryImpl(service: getIt<UserMoneyService>()),
  );
  getIt.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(
      service: getIt<AccountService>(),
      supabaseService: getIt<SupabaseService>(),
    ),
  );
  getIt.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(service: getIt<TransactionService>()),
  );
  getIt.registerLazySingleton<StatisticsRepository>(
    () => StatisticsRepositoryImpl(
      service: getIt<StatisticsService>(),
      supabaseService: getIt<SupabaseService>(),
    ),
  );
  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      service: getIt<CategoryService>(),
      supabaseService: getIt<SupabaseService>(),
    ),
  );
  getIt.registerLazySingleton<AppPreferencesRepository>(
    () => AppPreferencesRepositoryImpl(
        sharedPreferences: getIt<SharedPreferences>()),
  );
}

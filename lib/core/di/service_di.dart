import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moneyplus/core/security/app_secrets.dart';
import 'package:moneyplus/data/repository/secure_storage.dart';
import 'package:moneyplus/domain/repository/app_preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/data_source/supabase/account_service.dart';
import '../../data/data_source/supabase/auth_service.dart';
import '../../data/data_source/supabase/category_service.dart';
import '../../data/data_source/supabase/statistics_service.dart';
import '../../data/data_source/supabase/transaction_service.dart';
import '../../domain/service/account_service.dart';
import '../../domain/service/category_service.dart';
import '../../domain/service/statistics_service.dart';
import '../../domain/service/transaction_service.dart';
import '../security/protection_service.dart';
import '../service/firebase_service.dart';
import '../service/supabase_service.dart';
import '../../domain/service/auth_service.dart';
import '../../data/data_source/supabase/user_money_service.dart';
import '../../domain/service/user_money_service.dart';
import 'injection.dart';

void initServiceDI() {
  getIt.registerSingletonAsync<SharedPreferences>(
    () async => await SharedPreferences.getInstance(),
  );
  getIt.registerSingletonAsync<FirebaseService>(() async {
    final service = FirebaseService();
    await service.init();
    return service;
  });
  getIt.registerSingletonAsync<SecureStorage>(
          () async => SecureStorage(storage: FlutterSecureStorage())
  );
  getIt.registerSingletonAsync<ProtectionService>(
        () async => ProtectionService( secureStorage: getIt<SecureStorage>()),
    dependsOn: [SecureStorage],
  );
  getIt.registerSingletonAsync<AppSecrets>(
    () async =>
        AppSecrets(firebaseRemoteConfig: getIt<FirebaseService>().remoteConfig),
    dependsOn: [FirebaseService],
  );

  getIt.registerSingletonAsync<SupabaseService>(
    () async => SupabaseService(
      appSecrets: getIt<AppSecrets>(),
      appPreferencesRepository: getIt<AppPreferencesRepository>(),
    ),
    dependsOn: [AppSecrets],
  );

  getIt.registerSingletonAsync<AuthService>(
    () async => SupabaseAuthService(
      supabaseService: getIt<SupabaseService>(),
      appSecrets: getIt<AppSecrets>(),
    ),
    dependsOn: [SupabaseService, AppSecrets],
  );

  getIt.registerSingletonAsync<TransactionService>(
    () async => SupabaseTransactionService(
      service: getIt<SupabaseService>(),
    ),
    dependsOn: [SupabaseService],
  );

  getIt.registerSingletonAsync<UserMoneyService>(
    () async => SupabaseUserMoneyService(
      service: getIt<SupabaseService>(),
    ),
    dependsOn: [SupabaseService],
  );

  getIt.registerSingletonAsync<CategoryService>(
    () async => SupabaseCategoryService(
      service: getIt<SupabaseService>(),
    ),
    dependsOn: [SupabaseService],
  );

  getIt.registerSingletonAsync<AccountService>(
    () async => SupabaseAccountService(
      service: getIt<SupabaseService>(),
    ),
    dependsOn: [SupabaseService],
  );

  getIt.registerSingletonAsync<StatisticsService>(
    () async => SupabaseStatisticsService(
      service: getIt<SupabaseService>(),
    ),
    dependsOn: [SupabaseService],
  );
}



import '../../data/service/app_secrets_provider.dart';
import '../../data/service/supabase_service.dart';

import 'injection.dart';

void initServiceDI() {
  getIt.registerLazySingleton<AppSecretsProvider>(() => AppSecretsProvider());
  getIt.registerLazySingleton<SupabaseService>(
    () => SupabaseService(appSecretsProvider: getIt<AppSecretsProvider>()),
  );

}

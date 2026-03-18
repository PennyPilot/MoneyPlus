import 'package:moneyplus/core/security/app_secrets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/firebase_service.dart';
import '../service/supabase_service.dart';
import 'injection.dart';

void initServiceDI()  {
  getIt.registerSingletonAsync<SharedPreferences>(() async {
    return await SharedPreferences.getInstance();
  });

  getIt.registerSingletonAsync<FirebaseService>(() async {
    final service = FirebaseService();
    await service.init();
    return service;
  });

  getIt.registerSingletonAsync<AppSecrets>(
        () async => AppSecrets(
      firebaseRemoteConfig: getIt<FirebaseService>().remoteConfig,
    ),
    dependsOn: [FirebaseService],
  );

  getIt.registerSingletonAsync<SupabaseService>(
        () async => SupabaseService(appSecrets: getIt<AppSecrets>()),
    dependsOn: [AppSecrets],
  );
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moneyplus/core/security/app_secrets.dart';
import 'package:moneyplus/data/repository/secure_storage.dart';

import '../security/protection_service.dart';
import '../service/firebase_service.dart';
import '../service/supabase_service.dart';
import 'injection.dart';

void initServiceDI() {
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
    () async => SupabaseService(appSecrets: getIt<AppSecrets>()),
    dependsOn: [AppSecrets],
  );
}

import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../constants/app_constants.dart';

class AppSecrets {

  final FirebaseRemoteConfig firebaseRemoteConfig;
  AppSecrets({required this.firebaseRemoteConfig});

  Future<void> fetchRemoteConfig() async {
    await firebaseRemoteConfig.fetchAndActivate();
  }

  String getRemoteConfigSupaBaseUrl() {
    return firebaseRemoteConfig.getString(AppConstants.supabaseUrl);
  }

  String getRemoteConfigSupaBaseApiKey() {
    return firebaseRemoteConfig.getString(AppConstants.supabaseApiKey);
  }

  String getRemoteConfigGoogeWebClientId() {
    return firebaseRemoteConfig.getString(AppConstants.googleWebClientId);
  }

  String getRemoteConfigGoogeIosClientId() {
    return firebaseRemoteConfig.getString(AppConstants.googleIosClientId);
  }
}
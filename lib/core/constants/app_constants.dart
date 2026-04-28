class AppConstants {
  // Environment file
  static const String secretsEnvFile = "secrets.env";

  // Environment variable keys
  static const String supabaseUrl = "SUPA_BASE_URL";
  static const String supabaseApiKey = "SUPA_API_KEY";

  // Deep link paths
  static const String resetPasswordRedirect = "com.pennypilot.moneyplus://reset-password";

  static const String googleWebClientId = "GOOGLE_WEB_CLIENT_ID";
  static const String googleIosClientId = "GOOGLE_IOS_CLIENT_ID";
  static const String hashedSignature = "TALSEC_SIGNING_CERT_HASH";
  static const String watcherMail = "TALSEC_WATCHER_MAIL";
  static const String talsecAndroidPackageName = "TALSEC_ANDROID_PACKAGE_NAME";
  static const String talsecIosBundleId = "TALSEC_IOS_BUNDLE_ID";
  static const String talsecIosTeamId = "TALSEC_IOS_TEAM_ID";
  static const String talsecSupportedStores = "TALSEC_SUPPORTED_STORES";

  static const String categoryExistsMessage = "Category already exists";
}


abstract class AppPreferencesRepository {
  Future<AppTheme> getAppTheme();

  Future<void> setAppTheme(AppTheme themeMode);

  Future<AppLanguage> getAppLanguage();

  Future<void> setAppLanguage(AppLanguage language);

  Future<void> saveAccountSetupProgress(Map<String, dynamic> progress);

  Future<Map<String, dynamic>?> getAccountSetupProgress();

  Future<void> clearAccountSetupProgress();
}

enum AppTheme { dark, light, system }

enum AppLanguage { en, ar, system }
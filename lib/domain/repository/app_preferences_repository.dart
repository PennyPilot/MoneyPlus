
abstract class AppPreferencesRepository {
  Future<AppTheme> getAppTheme();

  Future<void> setAppTheme(AppTheme themeMode);

  Future<AppLanguage> getAppLanguage();

  Future<void> setAppLanguage(AppLanguage language);
}

enum AppTheme { dark, light, system }

enum AppLanguage { en, ar, system }
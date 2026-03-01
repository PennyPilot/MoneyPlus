import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repository/app_preferences_repository.dart';

class AppPreferencesRepositoryImpl implements AppPreferencesRepository {
  final SharedPreferences _sharedPreferences;

  AppPreferencesRepositoryImpl({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  @override
  Future<AppTheme> getAppTheme() async {
    final themeName = _sharedPreferences.getString(_themeKey);
    return AppTheme.values.firstWhere(
      (e) => e.name == themeName,
      orElse: () => AppTheme.system,
    );
  }

  @override
  Future<void> setAppTheme(AppTheme themeMode) async {
    await _sharedPreferences.setString(_themeKey, themeMode.name);
  }

  @override
  Future<AppLanguage> getAppLanguage() async {
    final langName = _sharedPreferences.getString(_languageKey);
    return AppLanguage.values.firstWhere(
      (e) => e.name == langName,
      orElse: () => AppLanguage.system,
    );
  }

  @override
  Future<void> setAppLanguage(AppLanguage language) async {
    await _sharedPreferences.setString(_languageKey, language.name);
  }

  static const String _languageKey = "APP_LANGUAGE";
  static const String _themeKey = "APP_THEME";
}
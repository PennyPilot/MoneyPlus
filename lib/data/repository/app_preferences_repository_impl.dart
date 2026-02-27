import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repository/app_preferences_repository.dart';


class AppPreferencesRepositoryImpl implements AppPreferencesRepository {
  final SharedPreferences _sharedPreferences;

  AppPreferencesRepositoryImpl({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  @override
  Future<AppTheme> getAppTheme() async {
    final themeName = _sharedPreferences.getString("APP_THEME");
    return AppTheme.values.firstWhere(
      (e) => e.name == themeName,
      orElse: () => AppTheme.system,
    );
  }

  @override
  Future<void> setAppTheme(AppTheme themeMode) async {
    await _sharedPreferences.setString("APP_THEME", themeMode.name);
  }

  @override
  Future<AppLanguage> getAppLanguage() async {
    final langName = _sharedPreferences.getString("APP_LANGUAGE");
    return AppLanguage.values.firstWhere(
      (e) => e.name == langName,
      orElse: () => AppLanguage.system,
    );
  }

  @override
  Future<void> setAppLanguage(AppLanguage language) async {
    await _sharedPreferences.setString("APP_LANGUAGE", language.name);
  }
}

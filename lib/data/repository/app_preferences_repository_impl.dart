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

  @override
  Future<void> saveAccountSetupProgress(Map<String, dynamic> progress) async {
    for (final entry in progress.entries) {
      if (entry.value is String) {
        await _sharedPreferences.setString(entry.key, entry.value as String);
      } else if (entry.value is int) {
        await _sharedPreferences.setInt(entry.key, entry.value as int);
      } else if (entry.value is double) {
        await _sharedPreferences.setDouble(entry.key, entry.value as double);
      } else if (entry.value is bool) {
        await _sharedPreferences.setBool(entry.key, entry.value as bool);
      } else if (entry.value is List<String>) {
        await _sharedPreferences.setStringList(entry.key, entry.value as List<String>);
      }
    }
  }

  @override
  Future<Map<String, dynamic>?> getAccountSetupProgress() async {
    final keys = [
      'name', 'email', 'password', 'step', 'salary', 'salaryDay', 
      'currencyId', 'balance', 'categories'
    ];
    final progress = <String, dynamic>{};
    bool hasData = false;
    for (final key in keys) {
      final value = _sharedPreferences.get(key);
      if (value != null) {
        progress[key] = value;
        hasData = true;
      }
    }
    return hasData ? progress : null;
  }

  @override
  Future<void> clearAccountSetupProgress() async {
    final keys = [
      'name', 'email', 'password', 'step', 'salary', 'salaryDay', 
      'currencyId', 'balance', 'categories'
    ];
    for (final key in keys) {
      await _sharedPreferences.remove(key);
    }
  }

  static const String _languageKey = "APP_LANGUAGE";
  static const String _themeKey = "APP_THEME";
}
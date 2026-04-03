import 'package:flutter/cupertino.dart';
import 'domain/repository/app_preferences_repository.dart';

@immutable
class AppPreferencesState {
  final AppTheme appTheme;
  final AppLanguage appLanguage;

  const AppPreferencesState({
    required this.appTheme,
    required this.appLanguage,
  });

  AppPreferencesState copyWith({
    AppTheme? appTheme,
    AppLanguage? appLanguage,
  }) {
    return AppPreferencesState(
      appTheme: appTheme ?? this.appTheme,
      appLanguage: appLanguage ?? this.appLanguage,
    );
  }
}

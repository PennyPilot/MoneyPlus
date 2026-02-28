import 'package:bloc/bloc.dart';
import 'package:moneyplus/app_preferences_state.dart';

import 'domain/repository/app_preferences_repository.dart';

class AppPreferencesCubit extends Cubit<AppPreferencesState> {
  final AppPreferencesRepository appThemeRepository;

  AppPreferencesCubit(this.appThemeRepository)
      : super(
    const AppPreferencesState(
      appTheme: AppTheme.system,
      appLanguage: AppLanguage.system,
    ),
  ) {
    getTheme();
    getLanguage();
  }

  Future<AppTheme> getTheme() async {
    final theme = await appThemeRepository.getAppTheme();
    emit(state.copyWith(appTheme: theme));
    return theme;
  }

  void setTheme(AppTheme theme) async {
    await appThemeRepository.setAppTheme(theme);
    emit(state.copyWith(appTheme: theme));
  }

  Future<AppLanguage> getLanguage() async {
    final language = await appThemeRepository.getAppLanguage();
    emit(state.copyWith(appLanguage: language));
    return language;
  }

  void setLanguage(AppLanguage language) async {
    await appThemeRepository.setAppLanguage(language);
    emit(state.copyWith(appLanguage: language));
  }
}

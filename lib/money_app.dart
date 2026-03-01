import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moneyplus/app_preferences_state.dart';
import 'package:moneyplus/app_prefernces_cubit.dart';
import 'package:moneyplus/design_system/theme/money_theme.dart';
import 'package:moneyplus/domain/repository/authentication_repository.dart';
import 'package:moneyplus/presentation/navigation/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/di/injection.dart';
import 'core/l10n/app_localizations.dart';
import 'domain/repository/app_preferences_repository.dart';

class AuthRedirectNotifier extends ChangeNotifier {
  final AuthenticationRepository _authRepository;
  late final StreamSubscription<AuthState> _subscription;
  bool _isPasswordRecovery = false;

  AuthRedirectNotifier(this._authRepository) {
    _subscription = _authRepository.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.passwordRecovery) {
        _isPasswordRecovery = true;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final _authRedirectNotifier =
    AuthRedirectNotifier(getIt<AuthenticationRepository>());
final _router = GoRouter(
  routes: $appRoutes,
  initialLocation: '/login',
  refreshListenable: _authRedirectNotifier,
  redirect: (context, state) {
    if (_authRedirectNotifier._isPasswordRecovery) {
      _authRedirectNotifier._isPasswordRecovery = false;
      return '/update_password';
    }
    return null;
  },
);

class MoneyApp extends StatelessWidget {
  const MoneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppPreferencesCubit(getIt<AppPreferencesRepository>()),
      child: const MoneyAppView(),
    );
  }
}

class MoneyAppView extends StatelessWidget {
  const MoneyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppPreferencesCubit, AppPreferencesState>(
      builder: (context, state) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Money++',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: state.appLanguage == AppLanguage.system
              ? null
              : Locale(state.appLanguage.name),
          theme: MoneyTheme.lightTheme,
          darkTheme: MoneyTheme.darkTheme,
          themeMode: _getThemeMode(state.appTheme),
          routerConfig: _router,
        );
      },
    );
  }
}

ThemeMode _getThemeMode(AppTheme theme) {
  switch (theme) {
    case AppTheme.light:
      return ThemeMode.light;
    case AppTheme.dark:
      return ThemeMode.dark;
    case AppTheme.system:
      return ThemeMode.system;
  }
}

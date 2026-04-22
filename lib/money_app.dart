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
  bool _isAuthenticated = false;
  bool _isInitialized = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get isInitialized => _isInitialized;
  bool get isPasswordRecovery => _isPasswordRecovery;

  AuthRedirectNotifier(this._authRepository) {
    _subscription = _authRepository.onAuthStateChange.listen(_onAuthStateChange);
  }

  void _onAuthStateChange(AuthState data) {
    final bool hasSession = data.session != null;
    final bool authChanged = hasSession != _isAuthenticated;
    final bool recoveryEvent = data.event == AuthChangeEvent.passwordRecovery;

    if (recoveryEvent) {
      _isPasswordRecovery = true;
    } else if (data.event == AuthChangeEvent.signedOut) {
      _isPasswordRecovery = false;
    }

    final bool wasInitialized = _isInitialized;
    _isAuthenticated = hasSession;
    _isInitialized = true;

    if (!wasInitialized) {
      Future.microtask(notifyListeners);
    } else if (authChanged || recoveryEvent) {
      notifyListeners();
    }
  }

  void clearPasswordRecovery() {
    _isPasswordRecovery = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final _authRedirectNotifier = AuthRedirectNotifier(getIt<AuthenticationRepository>());

class MoneyApp extends StatelessWidget {
  const MoneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppPreferencesCubit(getIt<AppPreferencesRepository>()),
      child: const MoneyAppView(),
    );
  }
}

class MoneyAppView extends StatefulWidget {
  const MoneyAppView({super.key});

  @override
  State<MoneyAppView> createState() => _MoneyAppViewState();
}

class _MoneyAppViewState extends State<MoneyAppView> {
  GoRouter? _router;

  @override
  void initState() {
    super.initState();
    _authRedirectNotifier.addListener(_onAuthReady);
  }

  void _onAuthReady() {
    if (!_authRedirectNotifier.isInitialized) return;
    _authRedirectNotifier.removeListener(_onAuthReady);
    setState(() => _router = _buildRouter());
  }

  GoRouter _buildRouter() {
    final startLocation = switch (true) {
      _ when _authRedirectNotifier.isPasswordRecovery => RoutePaths.updatePassword,
      _ when _authRedirectNotifier.isAuthenticated => RoutePaths.main,
      _ => RoutePaths.login,
    };

    return GoRouter(
      routes: $appRoutes,
      initialLocation: startLocation,
      refreshListenable: _authRedirectNotifier,
      redirect: _redirect,
    );
  }

  String? _redirect(BuildContext context, GoRouterState state) {
    final location = state.matchedLocation;
    final isAuthenticated = _authRedirectNotifier.isAuthenticated;
    final isPasswordRecovery = _authRedirectNotifier.isPasswordRecovery;

    if (isPasswordRecovery && location != RoutePaths.updatePassword) {
      return RoutePaths.updatePassword;
    }

    if (location == RoutePaths.updatePassword && isPasswordRecovery) {
      Future.microtask(() => _authRedirectNotifier.clearPasswordRecovery());
      return null;
    }

    final isPublicRoute = {
      RoutePaths.login,
      RoutePaths.createAccount,
      RoutePaths.forgetPassword,
      RoutePaths.onBoarding,
      RoutePaths.initial,
      RoutePaths.updatePassword,
    }.contains(location);

    if (!isAuthenticated && !isPublicRoute) return RoutePaths.login;
    if (isAuthenticated && isPublicRoute) return RoutePaths.main;

    return null;
  }

  @override
  void dispose() {
    _authRedirectNotifier.removeListener(_onAuthReady);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppPreferencesCubit, AppPreferencesState>(
      builder: (context, state) {
        final themeMode = _getThemeMode(state.appTheme);
        final locale = state.appLanguage == AppLanguage.system
            ? null
            : Locale(state.appLanguage.name);

        if (_router == null) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: MoneyTheme.lightTheme,
            darkTheme: MoneyTheme.darkTheme,
            themeMode: themeMode,
            home: const Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Money++',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          theme: MoneyTheme.lightTheme,
          darkTheme: MoneyTheme.darkTheme,
          themeMode: themeMode,
          routerConfig: _router!,
        );
      },
    );
  }
}

ThemeMode _getThemeMode(AppTheme theme) => switch (theme) {
  AppTheme.light => ThemeMode.light,
  AppTheme.dark => ThemeMode.dark,
  AppTheme.system => ThemeMode.system,
};

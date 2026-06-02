import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moneyplus/app_preferences_state.dart';
import 'package:moneyplus/app_prefernces_cubit.dart';
import 'package:moneyplus/design_system/theme/money_theme.dart';
import 'package:moneyplus/design_system/widgets/app_loading_indicator.dart';
import 'package:moneyplus/domain/entity/auth_status.dart';
import 'package:moneyplus/domain/repository/authentication_repository.dart';
import 'package:moneyplus/presentation/navigation/routes.dart';

import 'core/di/injection.dart';
import 'core/l10n/app_localizations.dart';
import 'domain/repository/app_preferences_repository.dart';

class AuthRedirectNotifier extends ChangeNotifier {
  final AuthenticationRepository _authRepository;
  late final StreamSubscription<AuthStatus> _subscription;
  AuthStatus _status = AuthStatus.initial;
  bool _isInitialized = false;

  AuthStatus get status => _status;
  bool get isInitialized => _isInitialized;
  bool get isAuthenticated =>
      _status == AuthStatus.authenticated ||
      _status == AuthStatus.accountSetupIncomplete;
  bool get isAccountSetupIncomplete =>
      _status == AuthStatus.accountSetupIncomplete;
  bool get isPasswordRecovery => _status == AuthStatus.passwordRecovery;

  AuthRedirectNotifier(this._authRepository) {
    _subscription =
        _authRepository.onAuthStatusChange.listen(_onAuthStatusChange);
    _authRepository.refreshAuthStatus();
  }

  void _onAuthStatusChange(AuthStatus status) {
    _status = status;
    _isInitialized = true;
    notifyListeners();
  }

  void clearPasswordRecovery() {
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

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
  late final AuthRedirectNotifier _authRedirectNotifier;

  @override
  void initState() {
    super.initState();
    _authRedirectNotifier = AuthRedirectNotifier(
      getIt<AuthenticationRepository>(),
    );
    _authRedirectNotifier.addListener(_onAuthReady);
  }

  void _onAuthReady() {
    if (!_authRedirectNotifier.isInitialized) return;
    _authRedirectNotifier.removeListener(_onAuthReady);

    setState(() => _router = _buildRouter());
  }

  GoRouter _buildRouter() {
    final startLocation = switch (true) {
      _ when _authRedirectNotifier.isPasswordRecovery =>
        RoutePaths.updatePassword,
      _ when _authRedirectNotifier.isAccountSetupIncomplete =>
        const LoginRoute(showResumeHint: true).location,
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
    final path = state.uri.path;
    final isAuthenticated = _authRedirectNotifier.isAuthenticated;
    final isPasswordRecovery = _authRedirectNotifier.isPasswordRecovery;
    final isAccountSetupIncomplete =
        _authRedirectNotifier.isAccountSetupIncomplete;

    if (isPasswordRecovery && path != RoutePaths.updatePassword) {
      return RoutePaths.updatePassword;
    }

    if (path == RoutePaths.updatePassword && isPasswordRecovery) {
      return null;
    }

    final isPublicRoute = {
      RoutePaths.login,
      RoutePaths.createAccount,
      RoutePaths.forgetPassword,
      RoutePaths.onBoarding,
      RoutePaths.initial,
      RoutePaths.updatePassword,
      RoutePaths.accountSetup,
    }.contains(path);

    if (!isAuthenticated && !isPublicRoute) {
      return RoutePaths.login;
    }

    if (isAuthenticated) {
      if (isAccountSetupIncomplete) {
        if (path == RoutePaths.login || path == RoutePaths.accountSetup) {
          return null;
        }
        return const LoginRoute(showResumeHint: true).location;
      }

      final isAuthRoute = {
        RoutePaths.login,
        RoutePaths.createAccount,
        RoutePaths.forgetPassword,
      }.contains(path);

      if (isAuthRoute || path == RoutePaths.accountSetup) {
        return RoutePaths.main;
      }
    }

    return null;
  }

  @override
  void dispose() {
    _authRedirectNotifier.removeListener(_onAuthReady);
    _authRedirectNotifier.dispose();
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

        final isDark = state.appTheme == AppTheme.dark ||
            (state.appTheme == AppTheme.system &&
                MediaQuery.platformBrightnessOf(context) == Brightness.dark);

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.transparent,
            statusBarColor: Colors.transparent,
            systemNavigationBarIconBrightness:
                isDark ? Brightness.light : Brightness.dark,
            statusBarIconBrightness:
                isDark ? Brightness.light : Brightness.dark,
          ),
          child: _router == null
              ? MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: MoneyTheme.lightTheme,
                  darkTheme: MoneyTheme.darkTheme,
                  themeMode: themeMode,
                  home: const Scaffold(
                      body: Center(child: AppLoadingIndicator())),
                )
              : MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  title: 'Money++',
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  locale: locale,
                  theme: MoneyTheme.lightTheme,
                  darkTheme: MoneyTheme.darkTheme,
                  themeMode: themeMode,
                  routerConfig: _router!,
                ),
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

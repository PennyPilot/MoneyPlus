import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:moneyplus/design_system/theme/money_theme.dart';
import 'package:moneyplus/domain/repository/authentication_repository.dart';
import 'package:moneyplus/presentation/navigation/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/di/injection.dart';
import 'core/l10n/app_localizations.dart';


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
final _authRedirectNotifier = AuthRedirectNotifier(getIt<AuthenticationRepository>());
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Money++',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      theme: MoneyTheme.lightTheme,
      routerConfig: _router,
    );
  }
}

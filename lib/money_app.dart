import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/theme/money_theme.dart';
import 'package:moneyplus/presentation/navigation/routes.dart';


final _router = GoRouter(
  routes: $appRoutes,
);

class MoneyApp extends StatelessWidget {
  const MoneyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Money++',
      theme: MoneyTheme.lightTheme,
      routerConfig: _router,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    return Scaffold(
        body: Center(
          child: Text(
            'Welcome Flutter!',
            style: typography.headline.small.copyWith(color: colors.primary),
          ),
        ),
    );
  }
}

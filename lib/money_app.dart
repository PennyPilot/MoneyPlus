import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/design_system/theme/money_theme.dart';
import 'package:moneyplus/di/injection.dart';
import 'package:moneyplus/presentation/login/cubit/login_cubit.dart';
import 'package:moneyplus/presentation/login/screen/login_screen.dart';

class MoneyApp extends StatelessWidget {
  const MoneyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Money++',
      theme: MoneyTheme.lightTheme,
      home: BlocProvider(
        create: (context) => getIt<LoginCubit>(),
        child: const LoginScreen(),
      ),
    );
  }
}

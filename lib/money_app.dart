import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/theme/money_theme.dart';
import 'package:moneyplus/widget/snack_bar.dart';

class MoneyApp extends StatelessWidget {
  const MoneyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Money++',
      theme: MoneyTheme.lightTheme,
      home: HomeScreen(),
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
      body: ElevatedButton(onPressed: (){
        moneySnackBar(context, " Success description", SnackBarType.success);
      }, child: Text("press"),
      ),
    );
  }
}

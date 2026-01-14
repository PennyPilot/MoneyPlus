import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/component/button/custom_button.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/theme/money_theme.dart';

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
      body: Padding(
        padding: EdgeInsetsGeometry.only(right: 16, left: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              spacing: 12,
              children: [
                CustomButton.defultButton(text: 'Login', onPressed: () {}),
                CustomButton.variantButton(text: 'Login', onPressed: () {}),
                CustomButton.disabledButton(text: 'Login'),
              ],
            ),
            SizedBox(height: 4),
            Column(
              spacing: 12,
              children: [
                CustomButton.defultSecondaryButton(
                  text: 'Login',
                  onPressed: () {},
                ),
                CustomButton.variantSecondaryButton(
                  text: 'Login',
                  onPressed: () {},
                ),
                CustomButton.disabledSecondaryButton(text: 'Login'),
              ],
            ),
            SizedBox(height: 4),
            Column(
              spacing: 12,
              children: [
                CustomButton.defultErrorButton(text: 'Login'),
                CustomButton.variantErrorButton(text: 'Login'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

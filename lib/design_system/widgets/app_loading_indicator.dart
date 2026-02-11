import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: context.colors.primary,
      ),
    );
  }
}
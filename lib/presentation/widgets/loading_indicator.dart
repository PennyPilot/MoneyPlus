import 'package:flutter/material.dart';
import '../../design_system/theme/money_colors.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: MoneyColors.light.primary),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import '../../design_system/theme/money_colors.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: context.colors.primary),
      ),
    );
  }
}

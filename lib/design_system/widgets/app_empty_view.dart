import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';

import 'buttons/button/default_button.dart';

class AppEmptyView extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const AppEmptyView({
    super.key,
    required this.title,
    required this.subtitle,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppAssets.imgNoAnalysis,
                width: 105,
                height: 96,
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: context.typography.title.medium.copyWith(
                  color: context.colors.title,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: context.typography.body.small.copyWith(
                  color: context.colors.body,
                ),
                textAlign: TextAlign.center,
              ),
              if (buttonText != null && onButtonPressed != null) ...[
                const SizedBox(height: 24),
                DefaultButton(
                  onPressed: onButtonPressed,
                  text: buttonText!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

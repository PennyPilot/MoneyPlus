import 'package:flutter/material.dart';
import 'package:moneyplus/core/l10n/app_localizations.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';

class AppErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AppErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: context.colors.primary,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.error_loading_statistics,
                style: context.typography.title.small.copyWith(
                  color: context.colors.title,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: context.typography.body.small.copyWith(
                  color: context.colors.body,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
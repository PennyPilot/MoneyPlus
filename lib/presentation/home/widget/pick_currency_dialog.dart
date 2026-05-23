import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';

class PickCurrencyDialog extends StatelessWidget {
  final VoidCallback onActionPressed;

  const PickCurrencyDialog({super.key, required this.onActionPressed});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final l10n = context.localizations;

    return Dialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                AppAssets.icCurrency,
                width: 40,
                height: 40,
                colorFilter: ColorFilter.mode(colors.primary, BlendMode.srcIn),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.pickCurrencyTitle,
              textAlign: TextAlign.center,
              style: typography.title.small.copyWith(
                color: colors.title,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.pickCurrencyMessage,
              textAlign: TextAlign.center,
              style: typography.body.medium.copyWith(
                color: colors.body,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                minimumSize: const Size(double.infinity, 54),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: onActionPressed,
              child: Text(
                l10n.goToAccount,
                style: typography.label.large.copyWith(
                  color: colors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

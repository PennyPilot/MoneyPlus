import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../design_system/assets/app_assets.dart';
import '../../../design_system/theme/money_extension_context.dart';
import '../../../design_system/widgets/app_bar.dart';
import '../widget/account_section.dart';
import '../widget/personal_info_card.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final typography = context.typography;

    return Scaffold(
      appBar: CustomAppBar(title: l10n.account),
      body: Container(
        decoration: BoxDecoration(color: colors.surface),
        padding: EdgeInsets.only(top: 24, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            personalInfoCard(
              image: '',
              name: "Xxxx",
              email: "Xxxx@gmail.com",
            ),
            SizedBox(height: 24),
            accountSection(
              title: l10n.manageCategories,
              iconPath: AppAssets.icSettings,
            ),
            accountSection(
              title: l10n.appLanguage,
              iconPath: AppAssets.icTranslation,
            ),
            accountSection(title: l10n.appTheme, iconPath: AppAssets.icSun),
            accountSection(
              title: l10n.currency,
              iconPath: AppAssets.icCurrency,
            ),
            accountSection(
              title: l10n.salarySettings,
              iconPath: AppAssets.iconMoney,
            ),
            accountSection(
              title: l10n.frequentlyAskedQuestion,
              iconPath: AppAssets.icHelp,
            ),
            accountSection(
              title: l10n.helpAndSupport,
              iconPath: AppAssets.icCustomerSupport,
              showDivider: false,
            ),
            Spacer(),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                "${l10n.appVersion} 1.0",
                style: typography.label.small.copyWith(color: colors.body),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

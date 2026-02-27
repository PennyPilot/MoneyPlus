import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../design_system/assets/app_assets.dart';
import '../../../design_system/theme/money_extension_context.dart';
import '../../../design_system/widgets/app_bar.dart';
import '../cubit/account_cubit.dart';
import '../cubit/account_state.dart';
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
      backgroundColor: colors.surface,
      appBar: CustomAppBar(title: l10n.account,backgroundColor: colors.surfaceLow),
      body: BlocProvider(
        create: (_) => getIt<AccountCubit>()..loadUserInfo(),
        child: BlocConsumer<AccountCubit, AccountState>(
          listener: (context, state) {},
          builder: (context, state) {
            return _buildBody(context, state, l10n, colors, typography);
          },
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AccountState state,
    AppLocalizations l10n,
    dynamic colors,
    dynamic typography,
  ) {
    if (state is AccountLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final user = state is AccountLoaded ? state.user : null;

    return Stack(
      children: [
        Positioned(
          child: Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              height: 150,

              child: Image.asset(
                AppAssets.glowBackground,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                personalInfoCard(
                  image: '',
                  name: user?.name ?? '',
                  email: user?.email ?? '',
                ),
                const SizedBox(height: 24),
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
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      "${l10n.appVersion} 1.0",
                      style: typography.label.small.copyWith(
                        color: colors.body,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

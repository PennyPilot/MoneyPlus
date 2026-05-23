import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/app_prefernces_cubit.dart';
import 'package:moneyplus/design_system/widgets/app_loading_indicator.dart';
import 'package:moneyplus/design_system/widgets/bottom_sheet.dart';
import 'package:moneyplus/design_system/widgets/buttons/button/default_button.dart';
import 'package:moneyplus/design_system/widgets/buttons/secondary/defult_secondary_button.dart';
import 'package:moneyplus/presentation/account/cubit/currency_selection_cubit.dart';
import 'package:moneyplus/presentation/account_setup/widget/currency_bottom_sheet.dart';
import 'package:moneyplus/domain/entity/currency.dart';
import 'package:moneyplus/presentation/navigation/routes.dart';

import '../../../core/di/injection.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../design_system/assets/app_assets.dart';
import '../../../design_system/theme/money_colors.dart';
import '../../../design_system/theme/money_extension_context.dart';
import '../../../design_system/theme/money_typography.dart';
import '../../../design_system/widgets/app_bar.dart';
import '../../../design_system/widgets/nav_bar.dart';
import '../../../design_system/widgets/snack_bar.dart';
import '../../main_container/cubit/main_cubit.dart';
import '../cubit/account_cubit.dart';
import '../cubit/account_state.dart';
import '../widget/account_section.dart';
import '../widget/language_selection_dialog.dart';
import '../widget/personal_info_card.dart';
import '../widget/theme_selection_dialog.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.localizations;
    final colors = context.colors;
    final typography = context.typography;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: CustomAppBar(
        title: l10n.account,
        backgroundColor: colors.surfaceLow,
        leading: AppBarCircleButton(
          assetPath: AppAssets.icArrowLeft,
          onTap: () {
            context.read<MainCubit>().onTabSelected(NavBarTab.home);
          },
        ),
      ),
      body: BlocProvider(
        create: (_) => getIt<AccountCubit>()..loadUserInfo(),
        child: BlocConsumer<AccountCubit, AccountState>(
          listener: (context, state) {
            if (state is LogoutSuccess) {
              const LoginRoute().go(context);
            }
          },
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
      MoneyColors colors,
      MoneyTypography typography,
      ) {
    if (state is AccountLoading) {
      return const AppLoadingIndicator();
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
              child: Image.asset(AppAssets.glowBackground, fit: BoxFit.contain),
            ),
          ),
        ),
        SafeArea(
          top: false,
          bottom: false,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  personalInfoCard(
                    context,
                    image: '',
                    name: user?.name ?? '',
                    email: user?.email ?? '',
                    onUpdateSuccess: () {
                      MSnackBar.success(
                        message: l10n.profileUpdatedSuccessfully,
                        title: l10n.success,
                      ).showSnackBar(context: context);
                      context.read<AccountCubit>().loadUserInfo();
                    },
                  ),
                  const SizedBox(height: 24),
                  accountSection(
                    context,
                    title: l10n.manageCategories,
                    iconPath: AppAssets.icSettings,
                    onTap: () => const ManageCategoriesRoute().push(context),
                  ),
                  accountSection(
                    context,
                    title: l10n.appLanguage,
                    iconPath: AppAssets.icTranslation,
                    onTap: () {
                      final language = context.read<AppPreferencesCubit>().state.appLanguage;
                      showDialog(
                        context: context,
                        builder: (context) => LanguageSelectionDialog(
                          currentLanguage: language,
                        ),
                      );
                    },
                  ),
                  accountSection(
                    context,
                    title: l10n.appTheme,
                    iconPath: AppAssets.icSun,
                    onTap: () {
                      final theme = context.read<AppPreferencesCubit>().state.appTheme;
                      showDialog(
                        context: context,
                        builder: (context) => ThemeSelectionDialog(
                          currentTheme: theme,
                        ),
                      );
                    },
                  ),
                  accountSection(
                    context,
                    title: l10n.currency,
                    iconPath: AppAssets.icCurrency,
                    onTap: () => _openCurrencyBottomSheet(context),
                  ),
                  accountSection(
                    context,
                    title: l10n.salarySettings,
                    iconPath: AppAssets.iconMoney,
                    onTap: () {
                      EditSalaryRoute().push(context);
                    },
                  ),
                  accountSection(
                    context,
                    title: l10n.frequentlyAskedQuestion,
                    iconPath: AppAssets.icHelp,
                  ),
                  accountSection(
                    context,
                    title: l10n.helpAndSupport,
                    iconPath: AppAssets.icCustomerSupport,
                  ),
                  accountSection(
                    context,
                    title: l10n.logout,
                    iconPath: AppAssets.icLogout,
                    showDivider: false,
                    onTap: () {
                      _showLogoutConfirmation(context);
                    },
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
                  const SizedBox(height: 100), // Bottom padding for edge-to-edge NavBar
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    final l10n = context.localizations;
    final cubit = context.read<AccountCubit>();

    showCustomBottomSheet(
      context: context,
      title: l10n.logout,
      content: Text(
        l10n.logout_confirmation,
        style: context.typography.body.medium.copyWith(color: context.colors.body),
      ),
      actionButtons: [
        DefaultSecondaryButton(
          text: l10n.logout_cancel,
          onPressed: () => Navigator.pop(context),
        ),
        DefaultButton(
          text: l10n.logout_confirm,
          onPressed: () {
            Navigator.pop(context);
            cubit.logout();
          },
        ),
      ],
    );
  }

  Future<void> _openCurrencyBottomSheet(BuildContext context) async {
    final accountCubit = context.read<AccountCubit>();
    final currencyCubit = getIt<CurrencySelectionCubit>()..fetchCurrencies();

    final result = await showModalBottomSheet<Currency>(
      context: context,
      useRootNavigator: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: context.colors.surface,
      useSafeArea: true,
      builder: (_) {
        return BlocBuilder<CurrencySelectionCubit, CurrencySelectionState>(
          bloc: currencyCubit,
          builder: (context, state) {
            return CurrencyBottomSheet(
              currencies: state.filteredCurrencies,
              isLoading: state.isLoading,
              query: state.query,
              onSearchChanged: (value) {
                currencyCubit.onSearchChanged(value);
              },
            );
          },
        );
      },
    );

    if (result != null) {
      await accountCubit.updateCurrency(result.id);
    }
  }
}

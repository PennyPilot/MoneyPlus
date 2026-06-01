import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/widgets/app_bar.dart';
import 'package:moneyplus/presentation/account_setup/screen/salary_management_step.dart';
import 'package:moneyplus/presentation/account_setup/screen/current_balance_step.dart';
import 'package:moneyplus/presentation/account_setup/screen/category_selection_step.dart';

import '../../../core/di/injection.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../design_system/theme/money_extension_context.dart';
import '../../../design_system/widgets/buttons/button/default_button.dart';
import '../../../design_system/widgets/snack_bar.dart';
import '../../navigation/routes.dart';
import '../cubit/account_setup_cubit.dart';
import '../cubit/account_setup_state.dart';

class AccountSetupScreen extends StatefulWidget {
  const AccountSetupScreen({super.key});

  @override
  State<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends State<AccountSetupScreen> {
  late PageController pageController;
  int currentIndex = 0;
  bool isFirstSync = true;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => getIt<AccountSetupCubit>()
        ..initUserData()
        ..init(),
      child: BlocConsumer<AccountSetupCubit, AccountSetupState>(
        listener: (context, state) {
          if (state.errorMessage.isNotEmpty) {
            MSnackBar.error(
              message: state.errorMessage,
              title: l10n.error,
            ).showSnackBar(context: context);
          }
          if (state.accountStep.index != currentIndex) {
            if (isFirstSync) {
              pageController.jumpToPage(state.accountStep.index);
              isFirstSync = false;
            } else {
              pageController.animateToPage(
                state.accountStep.index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
            setState(() {
              currentIndex = state.accountStep.index;
            });
          } else if (isFirstSync && state.accountStep.index == 0) {
            isFirstSync = false;
          }
          if (state.navigateToHome) {
            MainRoute().go(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: context.colors.surface,
            appBar: CustomAppBar(
              leading: AppBarCircleButton(
                assetPath: AppAssets.icArrowLeft,
                onTap: () {
                  if (state.accountStep == AccountSetupStep.salaryManagement) {
                    LoginRoute(showResumeHint: true).go(context);
                  } else {
                    context.read<AccountSetupCubit>().onPreviousStep();
                  }
                },
              ),
              title: l10n.accountSetup,
              trailing: SvgPicture.asset(AppAssets.appBrand),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsetsDirectional.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Indicator(currentIndex: currentIndex),
                    const SizedBox(height: 16),
                    Text(
                      l10n.stepOfTotal(currentIndex + 1, 3),
                      style: context.typography.label.small.copyWith(
                        color: context.colors.body,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.setUpYourAccount,
                      style: context.typography.headline.medium.copyWith(
                        color: context.colors.title,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: PageView(
                        controller: pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (index) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        children: [
                          SingleChildScrollView(
                              child: SalaryManagementStep(state: state)),
                          SingleChildScrollView(
                              child: CurrentBalanceStep(
                                  currency:
                                      state.selectedCurrency?.abbreviation ??
                                          "",
                                  currentBalanceState: state.currentBalance)),
                          SingleChildScrollView(
                              child: CategorySelectionStep(state: state))
                        ],
                      ),
                    ),
                    DefaultButton(
                      text: state.accountStep == AccountSetupStep.categorySelection
                          ? l10n.finishSetup
                          : l10n.next,
                      isEnabled: state.isButtonEnabled,
                      isLoading: state.isLoading,
                      onPressed: () {
                        context.read<AccountSetupCubit>().onNextStep();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final int currentIndex;

  const Indicator({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (index) {
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsetsDirectional.symmetric(horizontal: 4),
            height: 6,
            decoration: BoxDecoration(
              color: currentIndex == index
                  ? context.colors.title
                  : context.colors.stroke,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/widgets/app_bar.dart';
import 'package:moneyplus/presentation/account_setup/screen/page1.dart';
import 'package:moneyplus/presentation/account_setup/screen/page2.dart';
import 'package:moneyplus/presentation/account_setup/screen/account_setup_step_three.dart';

import '../../../core/di/injection.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../design_system/theme/money_extension_context.dart';
import '../../../design_system/widgets/buttons/button/default_button.dart';
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

  @override
  initState() {
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
    final cubit = getIt<AccountSetupCubit>();

    return BlocProvider(
      create: (context) => cubit..fetchCurrencies(),
      child: BlocListener<AccountSetupCubit, AccountSetupState>(
        listener: (context, state) {
          if (state.accountStep.index != currentIndex) {
            pageController.animateToPage(
              state.accountStep.index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            setState(() {
              currentIndex = state.accountStep.index;
            });
          }
          if (state.navigateToHome) {
            // navigate to home
          }
        },
        child: BlocBuilder<AccountSetupCubit, AccountSetupState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: context.colors.surface,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAppBar(
                        leading: AppBarCircleButton(
                          assetPath: AppAssets.icArrowLeft,
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        title: l10n.accountSetup,
                        trailing: SvgPicture.asset(AppAssets.appBrand),
                      ),
                      SizedBox(height: 36),
                      Indicator(currentIndex: currentIndex),
                      SizedBox(height: 16),
                      Text(
                        l10n.stepOfTotal(currentIndex + 1, 3),
                        style: context.typography.label.small.copyWith(
                          color: context.colors.body,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        l10n.setUpYourAccount,
                        style: context.typography.headline.medium.copyWith(
                          color: context.colors.title,
                        ),
                      ),
                      SizedBox(height: 4),
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
                            SingleChildScrollView(child: Page1(state: state,)),
                            SingleChildScrollView(child: Page2(currency: state.currency, currentBalanceState: state.currentBalance)),
                            SingleChildScrollView(child: AccountSetupStepThree(state: state)),

                          ],
                        ),
                      ),
                      DefaultButton(
                        text: state.accountStep == AccountSetupStep.step3
                            ? l10n.finishSetup
                            : l10n.next,
                        isEnabled: state.isButtonEnabled,
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

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/component/buttons/button/default_button.dart';
import 'package:moneyplus/design_system/widgets/app_bar.dart';
import 'package:moneyplus/presentation/account_setup/screen/page1.dart';

import '../../../design_system/theme/money_extension_context.dart';

class AccountSetupScreen extends StatefulWidget {
  const AccountSetupScreen({super.key});

  @override
  State<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends State<AccountSetupScreen> {
  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    int currentIndex = 0;

    return Scaffold(
      backgroundColor: context.colors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                leading: AppBarCircleButton(assetPath: AppAssets.icArrowLeft,onTap: () {}) ,
                title:"Account setup" ,
                trailing: SvgPicture.asset(AppAssets.appBrand,),
              ),
              SizedBox(height: 36,),
              Indicator(currentIndex: currentIndex),
              SizedBox(height: 16,),
              Text(
                "Step ${currentIndex+1} of 3",
                style: context.typography.label.small.copyWith(
                  color: context.colors.body,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Let’s set up your account",
                style: context.typography.headline.medium.copyWith(
                  color: context.colors.title,
                ),
              ),
              SizedBox(height: 4),
              Flexible(
                child: PageView(
                  controller: pageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  children: [
                    SingleChildScrollView(child: Page1())
                    // page2()
                    // page3()
                  ],
                ),
              ),
              DefaultButton(
                text: currentIndex == 2 ? "Finish setup" : "Next",
                isEnabled: false,
                onPressed: () {
                  if (currentIndex < 2) {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    // Navigate to home
                  }
                },
              ),
            ],
          ),
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
            margin: const EdgeInsets.symmetric(horizontal: 4),
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

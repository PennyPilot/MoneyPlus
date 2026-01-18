import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/component/buttons/money_button.dart';
import 'package:moneyplus/design_system/theme/money_colors.dart';
import 'package:moneyplus/design_system/theme/money_typography.dart';
import 'package:svg_flutter/svg.dart';

import '../../../design_system/theme/money_extension_context.dart';
import '../../../design_system/widgets/text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    return Scaffold(
      backgroundColor: colors.surface,
      body: CustomScrollView(
        slivers: [
          _sliverAppBar(),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsetsGeometry.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome again!',
                    style: typography.headline.medium.copyWith(
                      color: colors.title,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Enter your credentials to access your account',
                    style: typography.body.small.copyWith(color: colors.body),
                  ),
                  SizedBox(height: 16),
                  _buildForm(colors, typography),
                  Spacer(),
                  MoneyButton(
                    isEnabled: true,
                    innerShadow: BoxShadow(
                      blurRadius: 8,
                      offset: Offset(0, 4),
                      color: Color(0xDC143C29),
                    ),
                    outerShadow: BoxShadow(
                      blurRadius: 12,
                      offset: Offset(0, 4),
                      color: Color(0xFDECF080),
                    ),
                    backgroundColor: colors.primary,
                    disabledBackgroundColor: colors.disabled,
                    textColor: colors.onPrimary,
                    disabledTextColor: colors.onPrimary,
                    text: 'Login',
                  ),
                  SizedBox(height: 8),
                  _buildOrWidget(colors,typography),
                  SizedBox(height: 8),
                  MoneyButton(
                    backgroundColor: colors.surfaceLow,
                    disabledBackgroundColor: Colors.red,
                    borderWidth: 0.5,
                    borderColor: colors.stroke.withValues(alpha: 0.1),
                    textColor: colors.title,
                    disabledTextColor: Colors.grey,
                    text: 'Continue with Google',
                    iconPath: AppAssets.google,
                  ),
                  SizedBox(height: 8),
                  MoneyButton(
                    backgroundColor: colors.surfaceLow,
                    disabledBackgroundColor: Colors.red,
                    borderWidth: 0.5,
                    borderColor: colors.stroke.withValues(alpha: 0.1),
                    textColor: colors.title,
                    disabledTextColor: Colors.grey,
                    text: 'Create new account',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sliverAppBar() {
    return SliverAppBar(
      expandedHeight: 245,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Image.asset(AppAssets.background, fit: BoxFit.cover),
            Image.asset(AppAssets.logo, width: 99, height: 54),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(MoneyColors colors, MoneyTypography typography) {
    return Column(
      children: [
        MTextField(
          hint: "Email",
          value: "",
          leading: Padding(
            padding: EdgeInsetsGeometry.fromLTRB(8, 14, 16, 14),
            child: SvgPicture.asset(AppAssets.email),
          ),
          onChanged: (val) => print("Email: $val"),
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 12),
        MTextField(
          hint: "Password",
          value: "",
          leading: Padding(
            padding: EdgeInsetsGeometry.fromLTRB(8, 14, 16, 14),
            child: SvgPicture.asset(AppAssets.lock),
          ),
          trailing: Padding(
            padding: EdgeInsetsGeometry.only(top: 16, bottom: 16, left: 16),
            child: SvgPicture.asset(AppAssets.eye),
          ),
          onChanged: (val) => print("Password: $val"),
        ),
        SizedBox(height: 12),
        Align(
          alignment: Alignment.center,
          child: Text(
            'Forget password?',
            style: typography.label.medium.copyWith(color: colors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildOrWidget(MoneyColors colors, MoneyTypography typography) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: colors.stroke.withValues(alpha: 0.1),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: typography.label.small.copyWith(color: colors.body),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: colors.stroke.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }
}

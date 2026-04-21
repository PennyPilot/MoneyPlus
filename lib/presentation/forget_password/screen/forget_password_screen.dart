import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moneyplus/core/l10n/app_localizations.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/widgets/app_bar.dart';
import 'package:moneyplus/design_system/widgets/app_logo.dart';
import 'package:moneyplus/design_system/widgets/text_field.dart';
import 'package:moneyplus/domain/repository/authentication_repository.dart';
import 'package:moneyplus/presentation/forget_password/cubit/forget_password_cubit.dart';
import 'package:svg_flutter/svg.dart';

import '../../../core/di/injection.dart';
import '../../../design_system/theme/money_extension_context.dart';
import '../../../design_system/widgets/buttons/button/default_button.dart';
import '../cubit/forget_password_state.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ForgetPasswordCubit(getIt<AuthenticationRepository>(), getIt()),
      child: const _ForgetPasswordView(),
    );
  }
}

class _ForgetPasswordView extends StatelessWidget {
  const _ForgetPasswordView();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {},
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: colors.surface,
            appBar: CustomAppBar(
              title: l10n.forgetPasswordAppBarTitle,
              trailing: AppLogo(assetPath: AppAssets.icAppLogo),
              leading: AppBarCircleButton(assetPath: AppAssets.icArrowLeft
                ,onTap: () => context.pop(),),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16),
              child: DefaultButton(
                text: l10n.forgetPasswordButton,
                isEnabled: state.isEmailValid,
                isLoading: state.status == ForgetPasswordStatus.loading,
                onPressed: () {
                  context.read<ForgetPasswordCubit>().onClickForgetPassword();
                },
              ),
            ),
            body: Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 16,
                end: 16,
                top: 50,
                bottom: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 4),
                              blurRadius: 60,
                              color: const Color(0x33dc143c),
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          AppAssets.imgForgetPasswordLock,
                          height: 112,
                          width: 82,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.forgetPasswordTitle,
                      style: typography.headline.medium.copyWith(
                        color: colors.title,
                      ),
                    ),
                    Text(
                      l10n.forgetPasswordSubtitle,
                      style: typography.body.small.copyWith(color: colors.body),
                    ),
                    const SizedBox(height: 12),
                    MTextField(
                      hint: l10n.forgetPasswordEmailHint,
                      leading: SvgPicture.asset(
                        width: 24,
                        height: 24,
                        AppAssets.icEmail,
                      ),
                      value: state.email,
                      onChanged: (String value) {
                        context.read<ForgetPasswordCubit>().onEmailChanged(
                          value,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

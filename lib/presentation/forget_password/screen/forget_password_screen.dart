import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/core/l10n/app_localizations.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/component/buttons/button/default_button.dart';
import 'package:moneyplus/design_system/widgets/app_bar.dart';
import 'package:moneyplus/design_system/widgets/app_logo.dart';
import 'package:moneyplus/design_system/widgets/text_field.dart';
import 'package:moneyplus/di/injection.dart';
import 'package:moneyplus/domain/repository/authentication_repository.dart';
import 'package:moneyplus/presentation/forget_password/cubit/forget_password_cubit.dart';
import 'package:moneyplus/presentation/update_password/screen/update_password_screen.dart';
import 'package:svg_flutter/svg.dart';

import '../../../design_system/theme/money_extension_context.dart';
import '../cubit/forget_password_state.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgetPasswordCubit(getIt<AuthenticationRepository>()),
      child: const _ForgetPasswordView(),
    );
  }
}

class _ForgetPasswordView extends StatefulWidget {
  const _ForgetPasswordView();

  @override
  State<_ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<_ForgetPasswordView> {
  String _email = '';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state.status == ForgetPasswordStatus.passwordRecovery) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => UpdatePasswordScreen(email: _email),
            ),
          );
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: colors.surface,
            appBar: CustomAppBar(
              title: l10n.forgetPasswordAppBarTitle,
              trailing: AppLogo(assetPath: AppAssets.icAppLogo),
              leading: AppBarCircleButton(assetPath: AppAssets.icArrowLeft),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: DefaultButton(
                text: l10n.forgetPasswordButton,
                isEnabled: _email.isNotEmpty,
                isLoading: state.status == ForgetPasswordStatus.loading,
                onPressed: () {
                  context.read<ForgetPasswordCubit>().onClickForgetPassword(
                        _email,
                      );
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
                      value: _email,
                      onChanged: (String value) {
                        setState(() {
                          _email = value;
                        });
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

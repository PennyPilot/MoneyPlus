import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/core/l10n/app_localizations.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/component/buttons/button/default_button.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/app_bar.dart';
import 'package:moneyplus/design_system/widgets/snack_bar.dart';
import 'package:moneyplus/design_system/widgets/text_field.dart';
import 'package:moneyplus/di/injection.dart';
import 'package:moneyplus/domain/repository/authentication_repository.dart';
import 'package:moneyplus/money_app.dart';

import '../cubit/update_password_cubit.dart';
import '../cubit/update_password_state.dart';

class UpdatePasswordScreen extends StatelessWidget {
  final String email;

  const UpdatePasswordScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UpdatePasswordCubit(getIt<AuthenticationRepository>()),
      child: _UpdatePasswordView(email: email),
    );
  }
}

class _UpdatePasswordView extends StatefulWidget {
  final String email;

  const _UpdatePasswordView({required this.email});

  @override
  State<_UpdatePasswordView> createState() => _UpdatePasswordViewState();
}

class _UpdatePasswordViewState extends State<_UpdatePasswordView> {
  String _newPassword = '';
  String _confirmPassword = '';
  bool _isNewPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final typography = context.typography;

    return BlocConsumer<UpdatePasswordCubit, UpdatePasswordState>(
      listener: (context, state) {
        if (state.status == UpdatePasswordStatus.success) {
          // navigate to login screen when merged
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const MoneyApp()),
            (route) => false,
          );
        }
        if (state.status == UpdatePasswordStatus.error) {
          MoneySnackBar.error(
            message: 'Error updating password',
          ).showSnackBar(context: context);
        }
      },
      builder: (context, state) {
        final isLoading = state.status == UpdatePasswordStatus.loading;
        final isButtonEnabled =
            _newPassword.isNotEmpty &&
            _confirmPassword.isNotEmpty &&
            _newPassword == _confirmPassword &&
            !isLoading;

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: colors.surface,
            appBar: CustomAppBar(
              title: l10n.updatePasswordAppBarTitle,
              leading: AppBarCircleButton(assetPath: AppAssets.icArrowLeft),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: DefaultButton(
                text: l10n.updatePasswordButton,
                isLoading: isLoading,
                isEnabled: isButtonEnabled,
                onPressed: () {
                  context.read<UpdatePasswordCubit>().updatePassword(
                    _newPassword,
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
                  children: [
                    Container(
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
                    const SizedBox(height: 8),
                    Text(
                      l10n.updatePasswordTitle,
                      style: typography.headline.medium.copyWith(
                        color: colors.title,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      widget.email,
                      style: typography.body.small.copyWith(color: colors.body),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    MTextField(
                      hint: l10n.updatePasswordPasswordHint,
                      value: _newPassword,
                      obscureText: _isNewPasswordObscured,
                      maxLines: 1,
                      trailing: IconButton(
                        icon: Icon(
                          _isNewPasswordObscured
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isNewPasswordObscured = !_isNewPasswordObscured;
                          });
                        },
                      ),
                      onChanged: (value) {
                        setState(() {
                          _newPassword = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    MTextField(
                      hint: l10n.updatePasswordConfirmHint,
                      value: _confirmPassword,
                      obscureText: _isConfirmPasswordObscured,
                      maxLines: 1,
                      trailing: IconButton(
                        icon: Icon(
                          _isConfirmPasswordObscured
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordObscured =
                                !_isConfirmPasswordObscured;
                          });
                        },
                      ),
                      onChanged: (value) {
                        setState(() {
                          _confirmPassword = value;
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

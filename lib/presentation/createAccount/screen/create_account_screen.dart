import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/widgets/app_logo.dart';
import 'package:svg_flutter/svg.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../design_system/component/buttons/button/default_button.dart';
import '../../../design_system/theme/money_extension_context.dart';
import '../../../design_system/widgets/app_bar.dart';
import '../../../design_system/widgets/text_field.dart';
import '../../../domain/repository/authentication_repository.dart';
import '../../../domain/validator/authentication_validator.dart';
import '../cubit/create_account_cubit.dart';
import '../cubit/create_account_state.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => CreateAccountCubit(
        context.read<AuthenticationValidator>(),
        context.read<AuthenticationRepository>(),
      ),
      child: BlocBuilder<CreateAccountCubit, CreateAccountState>(
        builder: (context, state) {
          final cubit = context.read<CreateAccountCubit>();
          return Scaffold(
            appBar: CustomAppBar(
              title: l10n.createAccount,
              trailing: AppLogo(assetPath: AppAssets.appBrand),
              leading: AppBarCircleButton(
                assetPath: AppAssets.icArrowLeft,
                onTap: () => Navigator.pop(context),
              ),
            ),
            resizeToAvoidBottomInset: true,
            body: Container(
              color: colors.surface,
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.createNewAccount,
                      style: typography.headline.medium.copyWith(
                        color: colors.title,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.startTakingControl,
                      style: typography.body.small.copyWith(color: colors.body),
                    ),
                    const SizedBox(height: 24),
                    _textField(
                      hint: l10n.email,
                      value: state.email,
                      onChanged: cubit.emailChanged,
                      assetPath: AppAssets.icMail,
                    ),
                    const SizedBox(height: 12),
                    _textField(
                      hint: l10n.name,
                      value: state.name,
                      onChanged: cubit.nameChanged,
                      assetPath: AppAssets.icUser,
                    ),
                    const SizedBox(height: 12),
                    _passwordTextField(
                      password: state.password,
                      hint: l10n.password,
                      isPasswordVisible: state.isPasswordVisible,
                      onPasswordChanged: cubit.passwordChanged,
                      onToggleVisibility: cubit.togglePasswordVisibility,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.passwordLimit,
                      style: typography.label.small.copyWith(
                        color: colors.yellow,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            bottomNavigationBar: AnimatedPadding(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                left: 16,
                right: 16,
              ),
              child: SafeArea(
                child: DefaultButton(
                  text: l10n.create,
                  onPressed: () => cubit.submit(),
                  isEnabled: state.isEnabled,
                  isLoading: state.isLoading,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _textField({
    required String hint,
    required String value,
    required ValueChanged<String> onChanged,
    required String assetPath,
  }) {
    return MTextField(
      hint: hint,
      value: value,
      onChanged: (value) => onChanged(value),
      minLines: 1,
      maxLines: 1,
      leading: Padding(
        padding: EdgeInsetsGeometry.directional(top: 14, bottom: 14, end: 8),
        child: SvgPicture.asset(assetPath),
      ),
    );
  }

  Widget _passwordTextField({
    required String password,
    required String hint,
    required bool isPasswordVisible,
    required ValueChanged<String> onPasswordChanged,
    required VoidCallback onToggleVisibility,
  }) {
    return MTextField(
      hint: hint,
      value: password,
      onChanged: onPasswordChanged,
      obscureText: !isPasswordVisible,
      minLines: 1,
      maxLines: 1,
      leading: Padding(
        padding: const EdgeInsetsDirectional.only(top: 14, bottom: 14, end: 8),
        child: SvgPicture.asset(AppAssets.icSquareLock),
      ),
      trailing: Padding(
        padding: EdgeInsetsGeometry.only(top: 2),
        child: IconButton(
          onPressed: onToggleVisibility,
          icon: SvgPicture.asset(
            isPasswordVisible ? AppAssets.openEye : AppAssets.closedEye,
            height: 20,
            width: 20,
          ),
        ),
      ),
    );
  }
}

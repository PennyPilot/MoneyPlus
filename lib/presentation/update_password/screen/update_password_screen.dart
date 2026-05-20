import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/core/l10n/app_localizations.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/app_bar.dart';
import 'package:moneyplus/design_system/widgets/app_logo.dart';
import 'package:moneyplus/design_system/widgets/snack_bar.dart';
import 'package:moneyplus/design_system/widgets/text_field.dart';
import 'package:moneyplus/domain/repository/authentication_repository.dart';
import 'package:moneyplus/domain/validator/authentication_validator.dart';
import 'package:moneyplus/presentation/navigation/routes.dart';

import '../../../core/di/injection.dart';
import '../../../design_system/theme/money_colors.dart';
import '../../../design_system/theme/money_typography.dart';
import '../../../design_system/widgets/buttons/button/default_button.dart';
import '../cubit/update_password_cubit.dart';
import '../cubit/update_password_state.dart';

class UpdatePasswordScreen extends StatelessWidget {
  const UpdatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UpdatePasswordCubit(
          authenticationRepository: getIt<AuthenticationRepository>(),
          validator: getIt<AuthenticationValidator>()),
      child: const _UpdatePasswordView(),
    );
  }
}

class _UpdatePasswordView extends StatefulWidget {
  const _UpdatePasswordView();

  @override
  State<_UpdatePasswordView> createState() => _UpdatePasswordViewState();
}

class _UpdatePasswordViewState extends State<_UpdatePasswordView> {
  bool _isNewPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  @override
  void initState() {
    super.initState();
    context.read<UpdatePasswordCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final colors = context.colors;
    final typography = context.typography;
    final cubit = context.read<UpdatePasswordCubit>();

    return BlocConsumer<UpdatePasswordCubit, UpdatePasswordState>(
      listener: (context, state) {
        if (state.status == UpdatePasswordStatus.success) {
          MSnackBar.success(
                  message: localizations.updatePasswordSuccessMessage,
                  title: localizations.updatePasswordSuccessMessage)
              .showSnackBar(context: context);
          const LoginRoute().go(context);
        }
        if (state.status == UpdatePasswordStatus.error) {
          MSnackBar.error(
                  message: localizations.updatePasswordErrorMessage,
                  title: localizations.updatePasswordErrorMessage)
              .showSnackBar(context: context);
        }
      },
      builder: (context, state) {
        final isLoading = state.status == UpdatePasswordStatus.loading;

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: colors.surface,
            appBar: CustomAppBar(
              title: localizations.updatePasswordAppBarTitle,
              leading: AppBarCircleButton(assetPath: AppAssets.icArrowLeft),
              trailing: AppLogo(assetPath: AppAssets.icAppLogo),
            ),
            bottomNavigationBar: _buildBottomButton(localizations, cubit, isLoading, state),
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
                    _buildHeader(typography, colors, localizations, state),
                    const SizedBox(height: 12),
                    _buildForm(localizations, cubit, state),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    MoneyTypography typography,
    MoneyColors colors,
    AppLocalizations localizations,
    UpdatePasswordState state,
  ) {
    return Column(
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
          localizations.updatePasswordTitle,
          style: typography.headline.medium.copyWith(
            color: colors.title,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          state.email ?? '',
          style: typography.body.small.copyWith(color: colors.body),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForm(
    AppLocalizations localizations,
    UpdatePasswordCubit cubit,
    UpdatePasswordState state,
  ) {
    return Column(
      children: [
        MTextField(
          hint: localizations.updatePasswordPasswordHint,
          value: state.password,
          obscureText: _isNewPasswordObscured,
          maxLines: 1,
          trailing: IconButton(
            icon: Icon(
              _isNewPasswordObscured ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _isNewPasswordObscured = !_isNewPasswordObscured;
              });
            },
          ),
          onChanged: cubit.onPasswordChanged,
        ),
        const SizedBox(height: 16),
        MTextField(
          hint: localizations.updatePasswordConfirmHint,
          value: state.confirmPassword,
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
                _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
              });
            },
          ),
          onChanged: cubit.onConfirmPasswordChanged,
        ),
      ],
    );
  }

  Widget _buildBottomButton(
    AppLocalizations localizations,
    UpdatePasswordCubit cubit,
    bool isLoading,
    UpdatePasswordState state,
  ) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 16,
        right: 16,
      ),
      child: SafeArea(
        child: DefaultButton(
          text: localizations.updatePasswordButton,
          isLoading: isLoading,
          isEnabled: state.isEnabled,
          onPressed: cubit.updatePassword,
        ),
      ),
    );
  }
}

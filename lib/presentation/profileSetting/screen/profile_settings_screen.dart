import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';

import '../../../core/di/injection.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../design_system/theme/money_extension_context.dart';
import '../../../design_system/widgets/app_bar.dart';
import '../../../design_system/widgets/buttons/button/default_button.dart';
import '../../../design_system/widgets/snack_bar.dart';
import '../../../design_system/widgets/text_field.dart';
import '../cubit/profile_settings_cubit.dart';
import '../cubit/profile_settings_state.dart';

class ProfileSettingsScreen extends StatelessWidget {
  final String name;
  final String email;
  const ProfileSettingsScreen({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileSettingsCubit>()..initWithData(name, email),
      child: _ProfileSettingsScreenContent(),
    );
  }
}

class _ProfileSettingsScreenContent extends StatelessWidget {
  const _ProfileSettingsScreenContent();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final localizations = AppLocalizations.of(context)!;
    final cubit = context.read<ProfileSettingsCubit>();

    return BlocConsumer<ProfileSettingsCubit, ProfileSettingsState>(
      listener: (context, state) {
        if (state.isSavedSuccess) {
          context.pop(true);
          return;
        }
        if (state.errorMessage != null) {
          MSnackBar.error(
            message: state.errorMessage!,
            title: localizations.error,
          ).showSnackBar(context: context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(
            backgroundColor: colors.surfaceLow,
            title: localizations.editProfile,
            leading: AppBarCircleButton(
              assetPath: AppAssets.icArrowLeft,
              onTap: () => context.pop(),
            ),
          ),
          resizeToAvoidBottomInset: true,
          body: Container(
            color: colors.surface,
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _textField(
                    hint: localizations.name,
                    value: state.name,
                    onChanged: cubit.nameChanged,
                    assetPath: AppAssets.icUser,
                  ),
                  const SizedBox(height: 12),
                  _textField(
                    hint: localizations.email,
                    value: state.email,
                    onChanged: cubit.emailChanged,
                    assetPath: AppAssets.icEmail,
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
                text: localizations.save,
                onPressed: () => cubit.save(),
                isEnabled: state.isEnabled,
                isLoading: state.isLoading,
              ),
            ),
          ),
        );
      },
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
      onChanged: onChanged,
      minLines: 1,
      maxLines: 1,
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: SvgPicture.asset(assetPath),
      ),
    );
  }
}
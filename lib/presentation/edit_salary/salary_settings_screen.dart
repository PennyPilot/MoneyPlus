import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moneyplus/core/di/injection.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/app_bar.dart';
import 'package:moneyplus/presentation/edit_salary/salary_settings_cubit.dart';
import 'package:moneyplus/presentation/widgets/error_content.dart';
import 'package:svg_flutter/svg.dart';
import 'package:moneyplus/design_system/widgets/app_loading_indicator.dart';

import '../../design_system/widgets/buttons/button/default_button.dart';
import '../../design_system/widgets/snack_bar.dart';
import '../../design_system/widgets/text_field.dart';

class SalarySettingsScreen extends StatelessWidget {
  const SalarySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final localization = context.localizations;
    return Scaffold(
      appBar: CustomAppBar(
        title: localization.salarySettings,
        leading: AppBarCircleButton(
          assetPath: AppAssets.icArrowLeft,
          onTap: () => context.pop(),
        ),
        backgroundColor: colors.surfaceLow,
      ),
      body: BlocProvider(
        create: (context) => getIt<SalarySettingsCubit>()..getData(),
        child: BlocBuilder<SalarySettingsCubit, SalarySettingsState>(
          builder: (context, state) {
            var content = switch (state) {
              SalarySettingsLoading() => const AppLoadingIndicator(),
              SalarySettingsLoaded() => _loadedContent(context, state),
              SalarySettingsError() => errorContent(_getErrorMessage(state.failure, context)),
            };
            return content;
          },
        ),
      ),
    );
  }
}

Widget _loadedContent(BuildContext context, SalarySettingsLoaded state) {
  final colors = context.colors;
  final cubit = context.read<SalarySettingsCubit>();

  return Container(
    color: colors.surface,
    child: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 12,
              children: [
                _salaryBox(context, state, cubit),
                _salaryDayBox(context, state, cubit),
              ],
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 19),
            child: _saveButton(context, state, cubit),
          ),
        ),
      ],
    ),
  );
}

Widget _salaryBox(
  BuildContext context,
  SalarySettingsLoaded state,
  SalarySettingsCubit cubit,
) {
  final localization = context.localizations;
  return MTextField(
    hint: localization.salary,
    leading: Padding(
      padding: const EdgeInsetsDirectional.only(top: 14, bottom: 14, end: 8),
      child: SvgPicture.asset(AppAssets.iconMoney),
    ),
    keyboardType: TextInputType.number,
    value: state.salary,
    onChanged: (value) {
      cubit.updateSalary(value);
    },
  );
}

Widget _salaryDayBox(
  BuildContext context,
  SalarySettingsLoaded state,
  SalarySettingsCubit cubit,
) {
  final localization = context.localizations;
  return MTextField(
    hint: localization.salaryDay,
    leading: Padding(
      padding: const EdgeInsetsDirectional.only(top: 14, bottom: 14, end: 8),
      child: SvgPicture.asset(AppAssets.iconCalender),
    ),
    trailing: Padding(
      padding: const EdgeInsetsDirectional.only(top: 14, bottom: 14, end: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: context.colors.surface,
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          child: Text(
            localization.fromEachMonth,
            style: context.typography.label.small.copyWith(
              color: context.colors.body,
            ),
          ),
        ),
      ),
    ),
    keyboardType: TextInputType.number,
    value: state.salaryDay,
    onChanged: (value) {
      cubit.updateSalaryDay(value);
    },
  );
}

Widget _saveButton(
  BuildContext context,
  SalarySettingsLoaded state,
  SalarySettingsCubit cubit,
) {
  final localization = context.localizations;
  return DefaultButton(
    text: localization.save,
    isEnabled: state.isSaveButtonEnabled,
    onPressed: () {
      cubit.saveChanges().then((success) {
        if (success) {
          MSnackBar.success(
            message: localization.salary_saved,
            title: localization.success,
          ).showSnackBar(context: context);
          context.pop();
        } else {
          MSnackBar.error(
            message: localization.failed_to_save_salary,
            title: localization.error,
          ).showSnackBar(context: context);
        }
      });
    },
  );
}

String _getErrorMessage(SalarySettingsFailure failure, BuildContext context) {
  final localization = context.localizations;
  switch (failure) {
    case SalarySettingsFailure.loadFailed:
      return localization.failed_to_load_salary_settings;
    }
}

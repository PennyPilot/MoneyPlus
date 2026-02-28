import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/domain/model/form_status.dart';

import '../../../core/di/injection.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../design_system/theme/money_extension_context.dart';
import '../../../design_system/widgets/app_bar.dart';
import '../../../design_system/widgets/buttons/button/default_button.dart';
import '../../../design_system/widgets/snack_bar.dart';
import '../../../design_system/widgets/text_field.dart';
import '../../../design_system/widgets/text_field_date_Picker.dart';
import '../cubit/add_income_cubit.dart';
import '../cubit/add_income_state.dart';

class AddIncomeScreen extends StatelessWidget {
  const AddIncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddIncomeCubit>(),
      child: const _IncomeScreenContent(),
    );
  }
}

class _IncomeScreenContent extends StatelessWidget {
  const _IncomeScreenContent();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: CustomAppBar(
        title: localization.addIncome,
        backgroundColor: colors.surfaceLow,
        leading: AppBarCircleButton(
          assetPath: AppAssets.icArrowLeft,
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<AddIncomeCubit, AddIncomeState>(
        listener: (context, state) {
          final localization = AppLocalizations.of(context)!;

          if (state.status == FormStatus.success) {
            MSnackBar.success(
              message: localization.incomeAddedSuccessfully,
              title: '',
            ).showSnackBar(context: context);

            Navigator.pop(context);
          } else if (state.status == FormStatus.failure) {
            MSnackBar.error(
              message: state.errorMessage ?? localization.failedToAddIncome,
              title: '',
            ).showSnackBar(context: context);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildAmountSection(context, state),
                      _buildDateSection(context),
                      _buildNoteSection(context, state),
                    ],
                  ),
                ),
                _buildSaveButton(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAmountSection(BuildContext context, AddIncomeState state) {
    final colors = context.colors;
    final typography = context.typography;
    final localization = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: MTextField(
        hint: localization.amount,
        value: state.amount != null ? state.amount!.toStringAsFixed(0) : '',
        keyboardType: TextInputType.number,
        leading: Padding(
          padding: const EdgeInsetsDirectional.only(end: 8),
          child: SvgPicture.asset(
            AppAssets.icAmountGray,
            width: 24,
            height: 24,
          ),
        ),
        trailing: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.currency?.abbreviation ?? "",
                style: typography.label.small.copyWith(color: colors.body),
              ),
            ],
          ),
        ),
        onChanged: (value) {
          context.read<AddIncomeCubit>().onAmountChanged(value);
        },
      ),
    );
  }

  Widget _buildDateSection(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFieldDatePicker(
        hint: localization.date,
        onError: () {},
        onDateChange: (date) {
          context.read<AddIncomeCubit>().onDateChanged(date);
        },
      ),
    );
  }

  Widget _buildNoteSection(BuildContext context, AddIncomeState state) {
    final localization = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: MTextField(
        hint: localization.note,
        value: state.note,
        minLines: 4,
        maxLines: 6,
        onChanged: (value) {
          context.read<AddIncomeCubit>().onNoteChanged(value);
        },
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, AddIncomeState state) {
    final localization = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 19),
      child: DefaultButton(
        text: state.status == FormStatus.loading
            ? localization.saving
            : localization.add,
        onPressed: () {
          context.read<AddIncomeCubit>().onSubmitIncome();
        },
        isEnabled: state.canSubmitForm,
      ),
    );
  }
}

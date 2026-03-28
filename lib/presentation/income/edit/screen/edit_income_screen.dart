import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/domain/model/form_status.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../../../../design_system/theme/money_extension_context.dart';
import '../../../../../design_system/widgets/app_bar.dart';
import '../../../../../design_system/widgets/buttons/button/default_button.dart';
import '../../../../../design_system/widgets/snack_bar.dart';
import '../../../../../design_system/widgets/text_field.dart';
import '../../../../../design_system/widgets/text_field_date_Picker.dart';
import '../cubit/edit_income_cubit.dart';
import '../cubit/edit_income_state.dart';


class EditIncomeScreen extends StatelessWidget {
  final String transactionId;

  const EditIncomeScreen({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EditIncomeCubit>(param1: transactionId),
      child: const _EditIncomeScreenContent(),
    );
  }
}

class _EditIncomeScreenContent extends StatelessWidget {
  const _EditIncomeScreenContent();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: CustomAppBar(
        title: localization.editIncome,
        backgroundColor: colors.surfaceLow,
        leading: AppBarCircleButton(
          assetPath: AppAssets.icArrowLeft,
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<EditIncomeCubit, EditIncomeState>(
        listener: (context, state) {
          final localization = AppLocalizations.of(context)!;

          if (state.status == FormStatus.success) {
            MSnackBar.success(
              message: localization.incomeUpdatedSuccessfully,
              title: '',
            ).showSnackBar(context: context);
            Navigator.pop(context);
          } else if (state.status == FormStatus.failure) {
            MSnackBar.error(
              message: state.errorMessage ?? localization.failedToUpdateIncome,
              title: '',
            ).showSnackBar(context: context);
          }
        },
        builder: (context, state) {
          if (state.isLoadingTransaction) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildAmountSection(context, state),
                      _buildDateSection(context, state),
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

  Widget _buildAmountSection(BuildContext context, EditIncomeState state) {
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
          context.read<EditIncomeCubit>().onAmountChanged(value);
        },
      ),
    );
  }

  Widget _buildDateSection(BuildContext context, EditIncomeState state) {
    final localization = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFieldDatePicker(
        hint: localization.date,
        onError: () {},
        onDateChange: (date) {
          context.read<EditIncomeCubit>().onDateChanged(date);
        },
      ),
    );
  }

  Widget _buildNoteSection(BuildContext context, EditIncomeState state) {
    final localization = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: MTextField(
        hint: localization.note,
        value: state.note,
        minLines: 4,
        maxLines: 6,
        onChanged: (value) {
          context.read<EditIncomeCubit>().onNoteChanged(value);
        },
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, EditIncomeState state) {
    final localization = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 19),
      child: DefaultButton(
        text: state.status == FormStatus.loading
            ? localization.saving
            : localization.save,
        onPressed: () {
          context.read<EditIncomeCubit>().onSubmitIncome();
        },
        isEnabled: state.canSubmitForm,
      ),
    );
  }
}

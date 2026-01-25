import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/domain/model/form_status.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../design_system/theme/money_extension_context.dart';
import '../../../design_system/widgets/app_bar.dart';
import '../../../design_system/widgets/buttons/button/default_button.dart';
import '../../../design_system/widgets/snack_bar.dart';
import '../../../design_system/widgets/text_field.dart';
import '../../../design_system/widgets/text_field_date_Picker.dart';
import '../../../di/injection.dart';
import '../cubit/add_income_cubit.dart';
import '../cubit/add_income_state.dart';

class IncomeScreen extends StatelessWidget {
  const IncomeScreen({super.key});

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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: CustomAppBar(
        title: l10n.addIncome,
        backgroundColor: colors.surfaceLow,
        leading: AppBarCircleButton(
          assetPath: AppAssets.icArrowLeft,
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<AddIncomeCubit, AddIncomeState>(
        listener: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          
          if (state.status == FormStatus.success) {
            MSnackBar.success(
              message: l10n.incomeAddedSuccessfully,
            ).showSnackBar(context: context);
            
            Navigator.pop(context);
          } else if (state.status == FormStatus.failure) {
            MSnackBar.error(
              message: state.errorMessage ?? l10n.failedToAddIncome,
            ).showSnackBar(context: context);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MTextField(
                  hint: l10n.amount,
                  value: '',
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    context.read<AddIncomeCubit>().amountChanged(value);
                  },
                  leading: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: SvgPicture.asset(
                      AppAssets.icMoneyAmount,
                      width: 24,
                      height: 24,
                    ),
                  ),
                  trailing: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: colors.surface,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Text(
                      l10n.moneyAmount(
                        state.amount?.toStringAsFixed(0) ?? '0',
                        'IQD',
                      ),
                      style: TextStyle(
                        color: colors.body,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                TextFieldDatePicker(
                  hint: l10n.date,
                  onDateChange: (date) {
                    context.read<AddIncomeCubit>().dateChanged(date);
                  },
                  onError: () {},
                ),
                
                const SizedBox(height: 12),
                
                MTextField(
                  hint: l10n.note,
                  value: '',
                  maxLines: 5,
                  onChanged: (value) {
                    context.read<AddIncomeCubit>().noteChanged(value);
                  },
                ),
                
                const Spacer(),
                
                Padding(
                  padding: const EdgeInsets.only(bottom: 19),
                  child: DefaultButton(
                    text: state.status == FormStatus.loading 
                        ? l10n.saving
                        : l10n.add,
                    onPressed: () {
                      context.read<AddIncomeCubit>().submitIncome(l10n.salary);
                    },
                    isEnabled: state.isFormValid && 
                               state.status != FormStatus.loading,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

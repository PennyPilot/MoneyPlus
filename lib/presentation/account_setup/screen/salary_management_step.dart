import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/widgets/text_field.dart';
import 'package:moneyplus/presentation/account_setup/cubit/account_setup_state.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../design_system/theme/money_extension_context.dart';
import '../../../domain/entity/currency.dart';
import '../cubit/account_setup_cubit.dart';
import '../widget/currency_bottom_sheet.dart';

class Step1 extends StatefulWidget {
  final AccountSetupState state;

  const Step1({super.key, required this.state});

  @override
  State<Step1> createState() => _Step1State();
}

class _Step1State extends State<Step1> {

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.setSalary,
          style: context.typography.label.small.copyWith(
            color: context.colors.body,
          ),
        ),
        SizedBox(height: 24),
        GestureDetector(
          onTap: () => _openCurrencyBottomSheet(widget.state),
          child: AbsorbPointer(
            child: MTextField(
              key: ValueKey(widget.state.selectedCurrency?.id),
              hint: l10n.currency,
              leading: Padding(
                padding: const EdgeInsetsDirectional.only(
                  top: 14,
                  bottom: 14,
                  end: 8,
                ),
                child: SvgPicture.asset(AppAssets.iconMoney),
              ),
              trailing: Padding(
                padding: const EdgeInsetsDirectional.only(
                  top: 14,
                  bottom: 14,
                  end: 8,
                ),
                child: SvgPicture.asset(
                  AppAssets.icArrowDownRound,
                  height: 20,
                  width: 20,
                  colorFilter: ColorFilter.mode(
                    context.colors.body,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              value: widget.state.selectedCurrency != null
                  ? "${widget.state.selectedCurrency!.name}-${widget.state.selectedCurrency!.abbreviation}"
                  : "",
              onChanged: (value) {},
            ),
          ),
        ),
        SizedBox(height: 12),
        MTextField(
          hint: l10n.salary,
          leading: Padding(
            padding: const EdgeInsetsDirectional.only(
              top: 14,
              bottom: 14,
              end: 8,
            ),
            child: SvgPicture.asset(AppAssets.iconMoney),
          ),
          keyboardType: TextInputType.number,
          value: widget.state.salary,
          errorText: widget.state.salaryError.isNotEmpty ? l10n.salary_error_limit : null,
          inputFormatters: [
            LengthLimitingTextInputFormatter(9),
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (value) {
            context.read<AccountSetupCubit>().onSalaryChanged(value);
          },
        ),
        SizedBox(height: 12),
        MTextField(
          hint: l10n.salaryDay,
          leading: Padding(
            padding: const EdgeInsetsDirectional.only(
              top: 14,
              bottom: 14,
              end: 8,
            ),
            child: SvgPicture.asset(AppAssets.iconCalender),
          ),
          errorText: widget.state.salaryDayError.isNotEmpty ? l10n.salary_day_error_limit : null,
          trailing: Padding(
            padding: const EdgeInsetsDirectional.only(
              top: 14,
              bottom: 14,
              end: 8,
            ),
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
                  l10n.fromEachMonth,
                  style: context.typography.label.small.copyWith(
                    color: context.colors.body,
                  ),
                ),
              ),
            ),
          ),
          keyboardType: TextInputType.number,
          value: widget.state.salaryDay,
          inputFormatters: [
            LengthLimitingTextInputFormatter(2),
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (value) {
            context.read<AccountSetupCubit>().onSalaryDayChanged(value);
          },
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Future<void> _openCurrencyBottomSheet(AccountSetupState state) async {
    final cubit = context.read<AccountSetupCubit>();

    final result = await showModalBottomSheet<Currency>(
      context: context,
      useRootNavigator: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: context.colors.surface,
      useSafeArea: true,
      builder: (_) {
        return BlocBuilder<AccountSetupCubit, AccountSetupState>(
          bloc: cubit,
          builder: (context, state) {
            return CurrencyBottomSheet(
              currencies: state.filteredCurrencies,
              isLoading: state.isLoading,
              query: state.query,
              onSearchChanged: (value) {
                cubit.onSearchChanged(value);
              },
            );
          },
        );
      },
    );

    if (result != null) {
      cubit.onCurrencyChanged(result);
    }
  }
}

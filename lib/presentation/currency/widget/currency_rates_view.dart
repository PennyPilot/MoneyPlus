import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/app_loading_indicator.dart';
import 'package:moneyplus/design_system/widgets/text_field.dart';
import 'package:moneyplus/presentation/currency/cubit/currency_rates_cubit.dart';
import 'package:moneyplus/presentation/currency/cubit/currency_rates_state.dart';
import 'package:intl/intl.dart';
import '../../home/utils/StringFormattingHelpers.dart';

class CurrencyRatesView extends StatelessWidget {
  const CurrencyRatesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrencyRatesCubit, CurrencyRatesState>(
      builder: (context, state) {
        if (state.isLoading && state.rates.isEmpty) {
          return const Center(child: AppLoadingIndicator());
        }

        if (state.errorMessage != null && state.rates.isEmpty) {
          return Center(
            child: Text(
              state.errorMessage!,
              style: context.typography.label.medium.copyWith(color: context.colors.red),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _label(context, context.localizations.amount),
                  Text(
                    DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(state.date),
                    style: context.typography.label.xSmall?.copyWith(color: context.colors.hint),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              MTextField(
                hint: context.localizations.amount,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                value: state.amount,
                onChanged: (val) => context.read<CurrencyRatesCubit>().onAmountChanged(val),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label(context, context.localizations.from),
                        const SizedBox(height: 8),
                        _buildDropdown(
                          context: context,
                          value: state.baseCurrency?.id,
                          items: state.rates.map((r) {
                            return DropdownMenuItem(
                              value: r.id,
                              child: Text("${r.abbreviation} - ${r.name}"),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              context.read<CurrencyRatesCubit>().onBaseCurrencyChanged(val);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label(context, context.localizations.to),
                        const SizedBox(height: 8),
                        _buildDropdown(
                          context: context,
                          value: state.selectedTarget?.id,
                          items: state.rates.map((r) {
                            return DropdownMenuItem(
                              value: r.id,
                              child: Text("${r.abbreviation} - ${r.name}"),
                            );
                          }).toList(),
                          onChanged: (val) {
                            context.read<CurrencyRatesCubit>().onTargetCurrencyChanged(val);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha:0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: context.colors.primary.withValues(alpha:0.1)),
                ),
                child: Column(
                  children: [
                    Text(
                      context.localizations.result,
                      style: context.typography.label.small.copyWith(color: context.colors.body),
                    ),
                    const SizedBox(height: 8),
                    if (state.isLoading)
                      const SizedBox(height: 38, child: AppLoadingIndicator())
                    else
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "${formatWithCommas(state.result, decimalPlaces: 2)} ${state.selectedTarget?.abbreviation ?? ''}",
                          style: context.typography.headline.medium.copyWith(
                            color: context.colors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      "1 ${state.baseCurrency?.abbreviation ?? ''} = ${formatWithCommas(state.selectedTarget?.ratio ?? 0, decimalPlaces: 2)} ${state.selectedTarget?.abbreviation ?? ''}",
                      style: context.typography.label.xSmall?.copyWith(color: context.colors.hint),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _label(BuildContext context, String text) {
    return Text(
      text,
      style: context.typography.label.small.copyWith(
        color: context.colors.body,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildDropdown({
    required BuildContext context,
    required dynamic value,
    required List<DropdownMenuItem<dynamic>> items,
    required Function(dynamic) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: context.colors.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.stroke),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<dynamic>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: context.colors.body),
          style: context.typography.label.medium.copyWith(color: context.colors.title),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

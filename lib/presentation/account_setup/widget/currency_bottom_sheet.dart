import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/text_field.dart';
import 'package:moneyplus/design_system/widgets/app_loading_indicator.dart';
import 'package:moneyplus/domain/entity/currency.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../design_system/widgets/buttons/button/default_button.dart';
import '../cubit/account_setup_cubit.dart';
import '../cubit/account_setup_state.dart';
import 'currency_list.dart';

class CurrencyBottomSheet extends StatefulWidget {
  const CurrencyBottomSheet({super.key});

  @override
  State<CurrencyBottomSheet> createState() => _CurrencyBottomSheetState();
}

class _CurrencyBottomSheetState extends State<CurrencyBottomSheet> {
  final TextEditingController searchController = TextEditingController();
  Currency? selectedCurrency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<AccountSetupCubit, AccountSetupState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.currency,
                      style: context.typography.title.small.copyWith(
                        color: context.colors.title,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      AppAssets.iconCancel,
                      height: 20,
                      width: 20,
                      colorFilter: ColorFilter.mode(
                        context.colors.body,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
              child: Divider(
                color: context.colors.stroke,
                thickness: 1,
                height: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
              child: MTextField(
                hint: l10n.search,
                value: state.query,
                onChanged: (value) {
                  context.read<AccountSetupCubit>().onSearchChanged(value);
                },
                leading: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    top: 14,
                    bottom: 14,
                    end: 8,
                  ),
                  child: SvgPicture.asset(AppAssets.iconSearch),
                ),
              ),
            ),
            Expanded(
              child: state.isLoading
                  ? const AppLoadingIndicator()
                  : ListView.separated(
                      itemCount: state.filteredCurrencies.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context, int index) {
                        final currency = state.filteredCurrencies[index];
                        final isSelected = selectedCurrency?.id == currency.id;

                        return CurrencyList(
                          trailing: Text(
                            currency.abbreviation,
                            style: context.typography.label.medium.copyWith(
                              color: isSelected
                                  ? context.colors.primary
                                  : context.colors.title,
                            ),
                          ),
                          contentPadding: EdgeInsetsDirectional.only(
                            end: 16,
                            bottom: 8,
                            top: 8,
                            start: isSelected ? 7 : 16,
                          ),
                          onTap: () {
                            setState(() {
                              selectedCurrency = currency;
                            });
                          },
                          subtitleTextStyle: context.typography.label.small
                              .copyWith(
                                color: isSelected
                                    ? context.colors.primary
                                    : context.colors.body,
                              ),
                          titleTextStyle: context.typography.label.medium
                              .copyWith(
                                color: isSelected
                                    ? context.colors.primary
                                    : context.colors.title,
                              ),
                          title: currency.name,
                          subtitle: currency.country,
                          leading: isSelected
                              ? SvgPicture.asset(AppAssets.playArrow)
                              : null,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 16,
                          ),
                          child: Divider(
                            color: context.colors.stroke,
                            thickness: 1,
                            height: 1,
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.all(16),
              child: SafeArea(
                top: false,
                child: DefaultButton(
                  text: l10n.select,
                  isEnabled: selectedCurrency != null,
                  onPressed: () {
                    Navigator.pop(context, selectedCurrency);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

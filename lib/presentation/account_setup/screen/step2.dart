import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../design_system/assets/app_assets.dart';
import '../../../design_system/theme/money_extension_context.dart';
import '../../../design_system/widgets/text_field.dart';
import '../cubit/account_setup_cubit.dart';

class Step2 extends StatelessWidget {
  final String currency;
  final String currentBalanceState;

  const Step2({super.key, required this.currency, required this.currentBalanceState});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Text(
          l10n.how_much_money,
          style: context.typography.body.small.copyWith(
            color: context.colors.body,
          ),
        ),
        SizedBox(height: 24),
        MTextField(
          hint: l10n.current_balance,
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
                  currency,
                  style: context.typography.label.small.copyWith(
                    color: context.colors.body,
                  ),
                ),
              ),
            ),
          ),
          keyboardType: TextInputType.number,
          value: currentBalanceState,
          onChanged: (value) {
            context.read<AccountSetupCubit>().onCurrentBalanceChanged(value);
          },
        ),
      ],
    );
  }
}

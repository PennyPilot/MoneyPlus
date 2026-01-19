import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../design_system/component/buttons/button/default_button.dart';
import '../../../design_system/theme/money_extension_context.dart';
import '../../../design_system/widgets/app_bar.dart';
import '../../../design_system/widgets/text_field.dart';
import '../../../design_system/widgets/text_field_date_Picker.dart';

class IncomeScreen extends StatelessWidget {
  final String amount;
  final String currency;

  const IncomeScreen({super.key, this.amount= "1", this.currency = 'IQD'});

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
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 12 ,
          children: [
            MTextField(
              hint: l10n.amount,
              value: '',
              onChanged: (value) {},
              leading: Padding(
                padding: EdgeInsets.only(right: 8),
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
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                    l10n.moneyAmount(amount, currency),
                  style: TextStyle(
                  color: colors.body,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                ),
              ),
            ),

            TextFieldDatePicker(
              hint:l10n.date,
              onDateChange: (date) {
              },
              onError: () {

              },
            ),

            MTextField(
              hint: l10n.note,
              value: '',
              maxLines: 5,
              onChanged: (value) {},
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 19),
              child: DefaultButton(
                text: l10n.add,
                onPressed: (){},
                isEnabled: false,
              ),
            )
          ],
        ),
      ),
    );
  }
}

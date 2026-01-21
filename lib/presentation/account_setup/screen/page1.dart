import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/widgets/text_field.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../design_system/theme/money_extension_context.dart';
import 'currency_bottom_sheet.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {

  final TextEditingController currencyController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController dayController = TextEditingController();

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
        MTextField(
          hint: l10n.currency,
          leading: Padding(
            padding: const EdgeInsetsDirectional.only(top: 14,bottom: 14,end: 8),
            child: SvgPicture.asset(AppAssets.iconMoney),
          ),
          trailing: Padding(
            padding: const EdgeInsetsDirectional.only(top: 14,bottom: 14,end: 8),
            child: GestureDetector(
              onTap: () {
               _openCurrencyBottomSheet();
              },
              child: SvgPicture.asset(AppAssets.icArrowDownRound, height: 20,width: 20,),
            ),
          ),
          keyboardType: TextInputType.number,
          value: currencyController.text,
          onChanged: (value) {
            currencyController.text = value;
          },
        ),
        SizedBox(height: 12),
        MTextField(
          hint: l10n.salary,
          leading: Padding(
            padding: const EdgeInsetsDirectional.only(top: 14,bottom: 14,end: 8),
            child: SvgPicture.asset(AppAssets.iconMoney),
          ),
          keyboardType: TextInputType.number,
          value: salaryController.text,
          onChanged: (value) {
            salaryController.text = value;
          },
        ),
        SizedBox(height: 12),
        MTextField(
          hint: l10n.salaryDay,
          leading: Padding(
            padding: const EdgeInsetsDirectional.only(top: 14,bottom: 14,end: 8),
            child: SvgPicture.asset(AppAssets.iconCalender),
          ),
          trailing: Padding(
            padding: const EdgeInsetsDirectional.only(top: 14,bottom: 14,end: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: context.colors.surface,
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(vertical: 4,horizontal: 8),
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
          value: dayController.text ,
          onChanged: (value) {
            dayController.text = value;
          },
        ),
        SizedBox(height: 16,)
      ],
    );
  }
  Future<void> _openCurrencyBottomSheet() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: context.colors.surface,
      useSafeArea: true,
      builder: (context) => CurrencyBottomSheet(),
    );

    if (result != null) {
      setState(() {
        currencyController.text = result;
      });
    }
  }

}



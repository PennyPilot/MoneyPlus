import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/widgets/text_field.dart';

import '../../../design_system/theme/money_extension_context.dart';
import 'currency_bottom_sheet.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Set Salary",
          style: context.typography.label.small.copyWith(
            color: context.colors.body,
          ),
        ),
        SizedBox(height: 24),
        MTextField(
          hint: "Currency",
          leading: SvgPicture.asset(AppAssets.iconMoney),
          trailing: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      )
                  ),
                  backgroundColor: context.colors.surface,
                  useSafeArea: true,
                  builder: (context){
                    return CurrencyBottomSheet();
                  });
            },
            child: Icon(Icons.keyboard_arrow_down, size: 20),
          ),
          keyboardType: TextInputType.number,
          value: "",
          onChanged: (value) {},
        ),
        SizedBox(height: 12),
        MTextField(
          hint: "Salary",
          leading: SvgPicture.asset(AppAssets.iconMoney),
          keyboardType: TextInputType.number,
          value: "",
          onChanged: (value) {},
        ),
        SizedBox(height: 12),
        MTextField(
          hint: "Salary day",
          leading: SvgPicture.asset(AppAssets.iconCalender),
          trailing: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: context.colors.surfaceLow,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
              child: Text(
                "from each month",
                style: context.typography.label.small.copyWith(
                  color: context.colors.body,
                ),
              ),
            ),
          ),
          keyboardType: TextInputType.number,
          value: "",
          onChanged: (value) {

          },
        ),
      ],
    );
  }
}

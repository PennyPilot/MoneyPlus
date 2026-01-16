import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/component/buttons/button/default_button.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/text_field.dart';

class CurrencyBottomSheet extends StatelessWidget {
  const CurrencyBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    bool isSelected = false;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Currency",
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
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Divider(color: context.colors.stroke, thickness: 1, height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: MTextField(
              hint: "Search...",
              value: "",
              onChanged: (value) {},
              leading: SvgPicture.asset(AppAssets.iconSearch),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                if(!isSelected)
                  MediaQuery.removePadding(
                    context: context,
                    removeLeft: true,
                    child: Icon(
                      Icons.play_arrow,
                      size: 24,
                      color: context.colors.primary,
                    ),
                  ),
                Expanded(
                  child: ListView.separated(
                    itemCount: 30,
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        trailing: Text("JOD"),
                        leadingAndTrailingTextStyle: context.typography.label.medium
                            .copyWith(
                              color: isSelected
                                  ? context.colors.primary
                                  : context.colors.title,
                            ),
                        onTap: () {
                          isSelected = !isSelected;
                        },
                        selected: isSelected,
                        focusColor: context.colors.primary.withAlpha(8),
                        subtitleTextStyle: context.typography.label.small.copyWith(
                          color: isSelected
                              ? context.colors.primary
                              : context.colors.body,
                        ),
                        titleTextStyle: context.typography.label.medium.copyWith(
                          color: isSelected
                              ? context.colors.primary
                              : context.colors.title,
                        ),
                        title: Text("Iraqi Dinar"),
                        subtitle: Text("Egypt"),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(
                          color: context.colors.stroke,
                          thickness: 1,
                          height: 1,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          DefaultButton(
            text: "Select",
            isEnabled: false,
            onPressed: () {
              //  + select currency
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

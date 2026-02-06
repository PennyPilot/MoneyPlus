import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../design_system/assets/app_assets.dart';
import '../../../design_system/theme/money_extension_context.dart';
import '../../../design_system/widgets/text_field.dart';

class Page2 extends StatelessWidget {
  final String currency;
  const Page2({super.key, required this.currency});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final TextEditingController controller = TextEditingController();

    return Column(
      children: [
        Text(l10n.how_much_money,style: context.typography.body.small.copyWith(
          color: context.colors.body,),),
        SizedBox(height: 24,),
        MTextField(
          hint: l10n.currency,
          leading: Padding(
            padding: const EdgeInsetsDirectional.only(top: 14,bottom: 14,end: 8),
            child: SvgPicture.asset(AppAssets.iconMoney),
          ),
          trailing:  Padding(
            padding: const EdgeInsetsDirectional.only(top: 14,bottom: 14,end: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: context.colors.surface,
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(vertical: 4,horizontal: 8),
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
          value: controller.text,
          onChanged: (value) {
            controller.text = value;
          },
        ),
      ],
    );
  }
}

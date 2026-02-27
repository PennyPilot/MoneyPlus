import 'package:flutter/cupertino.dart';
import 'package:moneyplus/core/l10n/app_localizations.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/buttons/button/default_button.dart';
import 'package:svg_flutter/svg.dart';
import 'package:moneyplus/presentation/transactions/widget/add_transaction_bottom_sheet.dart';

class EmptyTransactions extends StatelessWidget {
  const EmptyTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final localizations = AppLocalizations.of(context)!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            SvgPicture.asset(
              AppAssets.icEmptyTransactionPattern,
              height: 150,
              width: 250,
            ),
            Positioned(
              top: 25,
              child: Image.asset(
                AppAssets.icEmptyTransactionImage,
                height: 112,
                width: 96,
              ),
            ),
          ],
        ),
        Text(
          localizations.no_transaction_record_title,
          style: typography.title.small.copyWith(color: colors.title),
        ),
        SizedBox(height: 4),
        Text(
          localizations.no_transaction_record_content,
          style: typography.body.small.copyWith(color: colors.body),
        ),
        SizedBox(height: 24),
        IntrinsicWidth(
          child: DefaultButton(
            text: localizations.add_transaction,
            onPressed: () => showAddTransactionBottomSheet(context),
          ),
        ),
      ],
    );
  }
}

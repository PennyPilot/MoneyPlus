import 'package:flutter/cupertino.dart';
import 'package:moneyplus/design_system/widgets/chip.dart';
import 'package:moneyplus/presentation/transactions/cubit/transaction_state.dart';

import '../../../core/l10n/app_localizations.dart';

class TabsRow extends StatelessWidget {
  final TransactionTabs selectedTab;
  final Function(TransactionTabs) onTabSelected;

  const TabsRow({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Row(
      children: [
        MChip(
          label: localizations.all,
          selected: selectedTab == TransactionTabs.all,
          onTap: () {
            onTabSelected(TransactionTabs.all);
          },
        ),
        SizedBox(width: 12),
        MChip(
          label: localizations.incomes,
          selected: selectedTab == TransactionTabs.incomes,
          onTap: () {
            onTabSelected(TransactionTabs.incomes);
          },
        ),
        SizedBox(width: 12),
        MChip(
          label: localizations.expenses,
          selected: selectedTab == TransactionTabs.expenses,
          onTap: () {
            onTabSelected(TransactionTabs.expenses);
          },
        ),
      ],
    );
  }
}

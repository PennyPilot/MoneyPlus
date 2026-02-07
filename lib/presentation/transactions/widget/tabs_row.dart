import 'package:flutter/cupertino.dart';
import 'package:moneyplus/design_system/widgets/chip.dart';
import 'package:moneyplus/presentation/transactions/cubit/transaction_state.dart';

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
    return Row(
      children: [
        MChip(
          label: "All",
          selected: selectedTab == TransactionTabs.all,
          onTap: () {
            onTabSelected(TransactionTabs.all);
          },
        ),
        SizedBox(width: 12),
        MChip(
          label: "Incomes",
          selected: selectedTab == TransactionTabs.incomes,
          onTap: () {
            onTabSelected(TransactionTabs.incomes);
          },
        ),
        SizedBox(width: 12),
        MChip(
          label: "Expenses",
          selected: selectedTab == TransactionTabs.expenses,
          onTap: () {
            onTabSelected(TransactionTabs.expenses);
          },
        ),
      ],
    );
  }
}

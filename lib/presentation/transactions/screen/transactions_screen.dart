import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moneyplus/core/l10n/app_localizations.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/app_bar.dart';
import 'package:moneyplus/design_system/widgets/chip.dart';
import 'package:moneyplus/domain/entity/transaction.dart';
import 'package:moneyplus/domain/entity/transaction_category.dart';
import 'package:moneyplus/domain/entity/transaction_type.dart';
import 'package:moneyplus/presentation/transactions/widget/transaction_row.dart';
import 'package:moneyplus/presentation/transactions/widget/transactions_list.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: colors.surface,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: CustomAppBar(
              title: "Transaction",
              backgroundColor: colors.surfaceLow,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 16, left: 16, top: 16),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  MChip(label: "All", selected: true, onTap: () {}),
                  SizedBox(width: 12),
                  MChip(label: "Incomes", selected: false, onTap: () {}),
                  SizedBox(width: 12),
                  MChip(label: "Expenses", selected: false, onTap: () {}),
                ],
              ),
            ),
          ),
          TransactionsList(
            transactions: [
              Transaction(
                id: 1,
                amount: 50000,
                currency: "IQD",
                type: TransactionType.expense,
                date: DateTime(2024, 12, 2),
                category: TransactionCategory(id: 1, name: "shopping"),
              ),
              Transaction(
                id: 4,
                amount: 5040,
                currency: "IQD",
                type: TransactionType.income,
                date: DateTime(2024, 12, 2),
                category: TransactionCategory(id: 1, name: "shopping"),
              ),
              Transaction(
                id: 2,
                amount: 230000,
                currency: "IQD",
                type: TransactionType.income,
                date: DateTime(2024, 12, 2),
                category: TransactionCategory(id: 1, name: "shopping"),
              ),
              Transaction(
                id: 3,
                amount: 530000,
                currency: "IQD",
                type: TransactionType.expense,
                date: DateTime(2024, 12, 2),
                category: TransactionCategory(id: 1, name: "shopping"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

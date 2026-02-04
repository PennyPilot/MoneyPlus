import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moneyplus/core/l10n/app_localizations.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/app_bar.dart';
import 'package:moneyplus/design_system/widgets/chip.dart';
import 'package:moneyplus/domain/entity/transaction_type.dart';
import 'package:moneyplus/presentation/transactions/widget/transaction_row.dart';

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
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 16, right: 16, left: 16),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  TransactionRow(
                    transactionType: TransactionType.income,
                    category: 'Shopping',
                    currency: 'IQD',
                    amount: 250000,
                    date: DateTime(2024, 12, 1),
                  ),
                  SizedBox(height: 12,),
                  TransactionRow(
                    transactionType: TransactionType.expense,
                    category: 'Shopping',
                    currency: 'IQD',
                    amount: 250000,
                    date: DateTime(2024, 12, 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

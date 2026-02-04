import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moneyplus/core/l10n/app_localizations.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/app_bar.dart';
import 'package:moneyplus/design_system/widgets/chip.dart';

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
          //SizedBox(height: 16,),
        ],
      ),
    );
  }
}

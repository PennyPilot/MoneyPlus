import 'package:flutter/material.dart';
import 'package:moneyplus/domain/entity/transaction.dart';
import 'package:moneyplus/presentation/navigation/routes.dart';
import 'package:moneyplus/presentation/transactions/widget/transaction_row.dart';

class TransactionsList extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionsList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 100), // Bottom padding for NavBar
      sliver: SliverList.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return TransactionRow(
            onTap: () {
              TransactionDetailsRoute(transaction.id).push(context);
            },
            transactionType: transaction.type,
            category: transaction.category.name,
            currency: transaction.currency,
            amount: transaction.amount,
            date: transaction.date,
          );
        },
      ),
    );
  }
}

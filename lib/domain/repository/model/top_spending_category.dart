import 'dart:ffi';

import 'package:moneyplus/domain/entity/transaction_category.dart';

class TopSpendingCategory {
  final TransactionCategory category;
  final int numberOfTransactions;
  final Double total;
  final String currency;
  final Float percentage;

  TopSpendingCategory({
    required this.category,
    required this.numberOfTransactions,
    required this.total,
    required this.currency,
    required this.percentage,
  });
}

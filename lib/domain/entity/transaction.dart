import 'package:moneyplus/domain/entity/transaction_category.dart';
import 'package:moneyplus/domain/entity/transaction_type.dart';

class Transaction {
  final String id;
  final double amount;
  final String currency;
  final TransactionType type;
  final DateTime date;
  final TransactionCategory category;
  final String note;

  Transaction({
    required this.id,
    required this.amount,
    required this.currency,
    required this.type,
    required this.date,
    required this.category,
    this.note = "",
  }) : assert(amount >= 0, 'Transaction amount cannot be negative');

  Transaction copyWith({
    String? id,
    double? amount,
    String? currency,
    TransactionType? type,
    DateTime? date,
    TransactionCategory? category,
    String? note,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      type: type ?? this.type,
      date: date ?? this.date,
      category: category ?? this.category,
      note: note ?? this.note,
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: (json['transaction_id'] ?? json['id'] ?? '').toString(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? '',
      type: json['transaction_type'] == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      category: TransactionCategory(
        id: json['category_id'] ?? 0,
        name: json['category'] ?? '',
      ),
      note: json['note'] ?? '',
    );
  }
}


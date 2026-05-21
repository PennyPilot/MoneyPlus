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
      id: (json['id'] ?? '').toString(),
      amount: (json['amount'] as num? ?? 0.0).toDouble(),
      currency: (json['currency_abbreviation'] ?? '').toString(),
      type: TransactionType.fromInt((json['transaction_type_id'] as num? ?? 2).toInt()),
      date: DateTime.parse(json['date']?.toString() ?? DateTime.now().toIso8601String()).toLocal(),
      category: json['category'] != null 
          ? TransactionCategory.fromJson(json['category']) 
          : TransactionCategory(id: 0, name: ''),
      note: json['note']?.toString() ?? "",
    );
  }
}

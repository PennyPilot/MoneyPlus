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
    // Determine transaction type
    TransactionType type = TransactionType.expense;
    final typeData = json['transaction_type_id'] ?? json['type_id'];
    if (typeData != null) {
      if (typeData is int) {
        type = typeData == 1 ? TransactionType.income : TransactionType.expense;
      } else if (typeData is String) {
        type = typeData.toLowerCase() == 'income' ? TransactionType.income : TransactionType.expense;
      }
    } else if (json['transaction_type'] != null) {
      type = json['transaction_type'].toString().toLowerCase() == 'income' 
          ? TransactionType.income 
          : TransactionType.expense;
    }

    return Transaction(
      id: (json['id'] ?? json['transaction_id'] ?? '').toString(),
      amount: (json['amount'] as num).toDouble(),
      currency: (json['currency_abbreviation'] ?? json['currency'] ?? '').toString(),
      type: type,
      date: DateTime.parse((json['created_at'] ?? json['date'] ?? DateTime.now().toIso8601String()).toString()).toLocal(),
      category: TransactionCategory(
        id: json['category_id'] as int? ?? 0,
        name: (json['category_name'] ?? json['category'] ?? '').toString(),
      ),
      note: (json['note'] ?? '').toString(),
    );
  }
}

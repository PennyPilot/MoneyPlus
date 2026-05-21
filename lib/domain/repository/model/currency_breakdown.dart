class CurrencyBreakdown {
  final int id;
  final String name;
  final String abbreviation;
  final double totalAmount;
  final int transactionCount;

  CurrencyBreakdown({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.totalAmount,
    required this.transactionCount,
  });

  factory CurrencyBreakdown.fromJson(Map<String, dynamic> json) {
    return CurrencyBreakdown(
      id: json['id'] as int,
      name: json['name'] as String,
      abbreviation: json['abbreviation'] as String,
      totalAmount: (json['total_amount'] as num).toDouble(),
      transactionCount: json['transaction_count'] as int,
    );
  }
}

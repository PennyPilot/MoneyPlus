
class DataPoint {
  final DateTime date;
  final double amount;

  const DataPoint({required this.date, required this.amount});

  DataPoint copyWith({DateTime? date, double? amount}) {
    return DataPoint(date: date ?? this.date, amount: amount ?? this.amount);
  }
}

class SpendingTrendPoint {
  final DateTime date;
  final double amount;

  const SpendingTrendPoint({required this.date, required this.amount});
}

class SpendingTrend {
  final List<SpendingTrendPoint> points;
  final String currency;

  const SpendingTrend({required this.points, required this.currency});

  bool get isEmpty => points.isEmpty;
}
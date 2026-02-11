class MonthlyOverview {
  final double income;
  final double expenses;
  final String currency;
  final double maxValue;
  final List<String> scaleLabels;

  const MonthlyOverview({
    required this.income,
    required this.expenses,
    required this.currency,
    required this.maxValue,
    required this.scaleLabels,
  });

  double get savings => income - expenses;

  bool get hasSavings => savings > 0;

  bool get isEmpty => income == 0 && expenses == 0;

  double get incomePercentage => maxValue > 0
      ? (income / maxValue).clamp(0.0, 1.0)
      : 0.0;

  double get expensePercentage => maxValue > 0
      ? (expenses / maxValue).clamp(0.0, 1.0)
      : 0.0;
}
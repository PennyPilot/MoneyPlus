abstract class StatisticsService {
  Future<dynamic> getMonthlyOverview({
    required int year,
    required int month,
  });

  Future<dynamic> getCategoriesBreakDown({
    required int year,
    required int month,
  });

  Future<dynamic> getSpendingTrend({
    required int year,
    required int month,
  });
}

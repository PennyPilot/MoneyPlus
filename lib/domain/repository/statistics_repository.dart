import '../entity/monthly_overview.dart';

abstract class StatisticsRepository {
  Future<MonthlyOverview?> getMonthlyOverview({required DateTime month});
}
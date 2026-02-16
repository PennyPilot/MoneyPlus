import '../../domain/entity/monthly_overview.dart';
import '../../domain/repository/statistics_repository.dart';

class FakeStatisticsRepository implements StatisticsRepository {
  @override
  Future<MonthlyOverview?> getMonthlyOverview({required DateTime month}) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return const MonthlyOverview(
      income: 5000.0,
      expenses: 3500.0,
      currency: "AED",
      maxValue: 6000.0,
      scaleLabels: ["0", "1k", "2k", "3k", "4k", "5k", "6k"],
    );
  }
}

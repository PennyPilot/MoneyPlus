import '../../domain/entity/monthly_overview.dart';
import '../../domain/repository/statistics_repository.dart';

class FakeStatisticsRepository implements StatisticsRepository {
  final bool shouldFail;
  final bool shouldReturnEmpty;

  FakeStatisticsRepository({
    this.shouldFail = false,
    this.shouldReturnEmpty = false,
  });

  @override
  Future<MonthlyOverview?> getMonthlyOverview({required DateTime month}) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (shouldFail) {
      throw Exception('Simulated network error');
    }

    if (shouldReturnEmpty) {
      return const MonthlyOverview(
        income: 0,
        expenses: 0,
        currency: 'IQD',
        maxValue: 100000,
        scaleLabels: ['0', '12.5K', '25K', '37.5K', '50K', '62.5K', '75K', '87.5K', '100K'],
      );
    }

    // Simulate successful response matching your UI design
    return const MonthlyOverview(
      income: 1500000,
      expenses: 850000,
      currency: 'IQD',
      maxValue: 2000000,
      scaleLabels: ['0', '250K', '500K', '750K', '1M', '1.25M', '1.5M', '1.75M', '2M'],
    );
  }
}
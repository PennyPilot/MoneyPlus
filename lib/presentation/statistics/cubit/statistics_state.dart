import '../../../domain/entity/monthly_overview.dart';

sealed class StatisticsState {
  const StatisticsState();
}

class StatisticsIdle extends StatisticsState {
  const StatisticsIdle();
}

class StatisticsLoading extends StatisticsState {
  const StatisticsLoading();
}

class StatisticsSuccess extends StatisticsState {
  final MonthlyOverview? monthlyOverview;
  final DateTime selectedMonth;

  const StatisticsSuccess({
    required this.monthlyOverview,
    required this.selectedMonth,
  });

  bool get hasNoData => monthlyOverview == null;
}

class StatisticsFailure extends StatisticsState {
  final String message;

  const StatisticsFailure(this.message);
}
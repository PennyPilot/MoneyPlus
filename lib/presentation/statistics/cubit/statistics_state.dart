import 'package:moneyplus/domain/entity/categories_breakdown.dart';

import '../../../domain/entity/monthly_overview.dart';
import '../../../domain/entity/spending_trend_point.dart';

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
  final MonthlyOverview monthlyOverview;
  final DateTime selectedMonth;
  final CategoriesBreakdown categoriesBreakdown;
  final SpendingTrend spendingTrend;

  const StatisticsSuccess({
    required this.monthlyOverview,
    required this.selectedMonth,
    required this.categoriesBreakdown,
    required this.spendingTrend,
  });

  bool get hasNoData => monthlyOverview.isEmpty && categoriesBreakdown.categories.isEmpty;
}

class StatisticsFailure extends StatisticsState {
  final String message;

  const StatisticsFailure(this.message);
}

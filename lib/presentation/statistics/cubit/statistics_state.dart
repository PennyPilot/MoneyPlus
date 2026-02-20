import 'package:moneyplus/domain/entity/categories_breakdown.dart';

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
  final MonthlyOverview monthlyOverview;
  final DateTime selectedMonth;
  final CategoriesBreakdown categoriesBreakdown;

  const StatisticsSuccess({
    required this.monthlyOverview,
    required this.selectedMonth,
    required this.categoriesBreakdown,
  });

  bool get hasNoData => monthlyOverview.isEmpty && categoriesBreakdown.categories.isEmpty;
}

class StatisticsFailure extends StatisticsState {
  final String message;

  const StatisticsFailure(this.message);
}

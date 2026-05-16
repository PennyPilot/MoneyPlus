import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/spending_trend_point.dart';
import '../../../domain/repository/statistics_repository.dart';
import 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final StatisticsRepository _repository;

  StatisticsCubit({required StatisticsRepository repository})
    : _repository = repository,
      super(const StatisticsIdle());

  Future<void> loadStatistics({DateTime? month}) async {
    final now = DateTime.now();
    final selectedMonth = month ?? DateTime(now.year, now.month, 1);
    emit(const StatisticsLoading());

    final monthlyOverviewResult = await _repository.getMonthlyOverview(
      month: selectedMonth,
    );

    monthlyOverviewResult.when(
      onSuccess: (monthlyOverview) async {
        final categoriesResult = await _repository.getCategoriesBreakDown(
          date: selectedMonth,
        );
        final trendResult = await _repository.getSpendingTrend(
          month: selectedMonth,
        );

        categoriesResult.when(
          onSuccess: (categoriesBreakdown) {
            final spendingTrend = trendResult.when(
              onSuccess: (trend) => trend,
              onError: (_) => SpendingTrend(points: [], currency: 'IQD'),
            );

            emit(
              StatisticsSuccess(
                monthlyOverview: monthlyOverview,
                selectedMonth: selectedMonth,
                categoriesBreakdown: categoriesBreakdown,
                spendingTrend: spendingTrend,
              ),
            );
          },
          onError: (error) => emit(StatisticsFailure(error.message)),
        );
      },
      onError: (error) => emit(StatisticsFailure(error.message)),
    );
  }

  void changeMonth(DateTime month) {
    loadStatistics(month: month);
  }
}

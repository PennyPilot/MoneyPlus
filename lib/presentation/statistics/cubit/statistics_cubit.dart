import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repository/statistics_repository.dart';
import 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final StatisticsRepository _repository;

  StatisticsCubit({required StatisticsRepository repository})
    : _repository = repository,
      super(const StatisticsIdle());

  Future<void> loadStatistics({DateTime? month}) async {
    final selectedMonth = month ?? DateTime(2026, 2, 1);

    emit(const StatisticsLoading());

    final monthlyOverviewResult = await _repository.getMonthlyOverview(
      month: selectedMonth,
    );
    monthlyOverviewResult.when(
      onSuccess: (monthlyOverview) async {
        final categoriesBreakdownResult =
            await _repository.getCategoriesBreakDown(date:selectedMonth);

        categoriesBreakdownResult.when(
          onSuccess: (categoriesBreakdown) {
            emit(
              StatisticsSuccess(
                monthlyOverview: monthlyOverview,
                selectedMonth: selectedMonth,
                categoriesBreakdown: categoriesBreakdown,
              ),
            );
          },
          onError: (error) {
            emit(StatisticsFailure(error.message));
          },
        );
      },
      onError: (error) {
        emit(StatisticsFailure(error.message));
      },
    );
  }

  void changeMonth(DateTime month) {
    loadStatistics(month: month);
  }
}

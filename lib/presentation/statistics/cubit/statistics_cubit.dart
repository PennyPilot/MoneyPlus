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

    try {
      final monthlyOverview = await _repository.getMonthlyOverview(
        month: selectedMonth,
      );

      emit(
        StatisticsSuccess(
          monthlyOverview: monthlyOverview,
          selectedMonth: selectedMonth,
        ),
      );
    } catch (e) {
      emit(StatisticsFailure(e.toString()));
    }
  }

  void changeMonth(DateTime month) {
    loadStatistics(month: month);
  }
}

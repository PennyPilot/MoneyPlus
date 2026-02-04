import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repository/statistics_repository.dart';
import 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final StatisticsRepository statisticsRepository;

  StatisticsCubit({required this.statisticsRepository})
      : super(StatisticsState.initial());

  Future<void> getCategoriesBreakdown(DateTime date) async {
    emit(state.copyWith(status: StatisticsStatus.loading));

    final result = await statisticsRepository.getCategoriesBreakDown(date);

    result.when(
      onSuccess: (categoriesBreakdown) {
        emit(state.copyWith(
          status: StatisticsStatus.success,
          categoriesBreakdown: categoriesBreakdown,
        ));
      },
      onError: (error) {
        emit(state.copyWith(status: StatisticsStatus.failure, error: error));
      },
    );
  }
}

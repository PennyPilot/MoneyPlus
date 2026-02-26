import '../entity/monthly_overview.dart';

import 'package:moneyplus/domain/entity/categories_breakdown.dart';

import '../../core/errors/result.dart';

abstract class StatisticsRepository {
  Future<Result<MonthlyOverview>> getMonthlyOverview({required DateTime month});
  Future<Result<CategoriesBreakdown>> getCategoriesBreakDown({required DateTime date});
}

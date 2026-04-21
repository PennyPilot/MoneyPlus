import '../entity/monthly_overview.dart';

import 'package:moneyplus/domain/entity/categories_breakdown.dart';

import '../../core/errors/result.dart';
import '../entity/spending_trend_point.dart';

abstract class StatisticsRepository {
  Future<Result<MonthlyOverview>> getMonthlyOverview({required DateTime month});
  Future<Result<CategoriesBreakdown>> getCategoriesBreakDown({required DateTime date});
  Future<Result<SpendingTrend>> getSpendingTrend({required DateTime month});
}

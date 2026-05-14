import '../../../core/service/supabase_service.dart';
import '../../../domain/service/statistics_service.dart';

class SupabaseStatisticsService implements StatisticsService {
  final SupabaseService service;

  SupabaseStatisticsService({required this.service});

  @override
  Future<dynamic> getMonthlyOverview({
    required int year,
    required int month,
  }) async {
    final client = await service.getClient();
    return await client.rpc(
      'get_monthly_overview',
      params: {'in_year': year, 'in_month': month},
    );
  }

  @override
  Future<dynamic> getCategoriesBreakDown({
    required int year,
    required int month,
  }) async {
    final client = await service.getClient();
    return await client.rpc(
      'get_expenses_categories_breakdown',
      params: {'in_year': year, 'in_month': month},
    );
  }

  @override
  Future<dynamic> getSpendingTrend({
    required int year,
    required int month,
  }) async {
    final client = await service.getClient();
    return await client.rpc(
      'get_spending_trend',
      params: {'in_year': year, 'in_month': month},
    );
  }
}

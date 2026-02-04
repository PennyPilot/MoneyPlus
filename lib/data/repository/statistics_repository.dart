import 'package:moneyplus/domain/entity/categories_breakdown.dart';

import '../../core/errors/error_model.dart';
import '../../core/errors/result.dart';
import '../../domain/repository/statistics_repository.dart';
import '../service/app_secrets_provider.dart';
import '../service/supabase_service.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final SupabaseService supabaseService;
  StatisticsRepositoryImpl({
    required this.supabaseService,
  });

  @override
  Future<Result<CategoriesBreakdown>> getCategoriesBreakDown(
    DateTime date,
  ) async {
    try {
      final client = await supabaseService.getClient();
      final data = await client.rpc(
        'get_expenses_categories_breakdown',
        params: {'in_year': 2026, 'in_month': 2},
      );
      return Result.success(
        CategoriesBreakdown.fromJson(data),
      );
    } catch (e) {
      return Result.error(ErrorModel(e.toString()));
    }
  }
}

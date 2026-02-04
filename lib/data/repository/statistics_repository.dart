import 'package:moneyplus/domain/entity/categories_breakdown.dart';

import '../../core/errors/error_model.dart';
import '../../core/errors/result.dart';
import '../../domain/repository/statistics_repository.dart';
import '../service/app_secrets_provider.dart';
import '../service/supabase_service.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final SupabaseService supabaseService;
  final AppSecretsProvider appSecrets;

  StatisticsRepositoryImpl({
    required this.supabaseService,
    required this.appSecrets,
  });

  @override
  Future<Result<CategoriesBreakdown>> getCategoriesBreakDown(
    DateTime date,
  ) async {
    try {
      final client = await supabaseService.getClient();
      final data = await client.rpc(
        'get_categories_breakdown',
        params: {'date': date.toIso8601String()},
      );
      return Result.success(
        CategoriesBreakdown.fromJson(data),
      );
    } catch (e) {
      return Result.error(ErrorModel(e.toString()));
    }
  }
}

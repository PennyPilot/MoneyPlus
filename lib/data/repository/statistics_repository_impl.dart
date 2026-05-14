import '../../core/errors/error_model.dart';
import '../../core/errors/result.dart';
import '../../core/service/supabase_service.dart';
import '../../domain/entity/categories_breakdown.dart';
import '../../domain/entity/monthly_overview.dart';
import '../../domain/entity/spending_trend_point.dart';
import '../../domain/repository/statistics_repository.dart';
import '../../domain/service/statistics_service.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final StatisticsService service;
  final SupabaseService _supabaseService;

  StatisticsRepositoryImpl({
    required this.service,
    required SupabaseService supabaseService,
  }) : _supabaseService = supabaseService;

  @override
  Future<Result<MonthlyOverview>> getMonthlyOverview({
    required DateTime month,
  }) async {
    try {
      final client = await _supabaseService.getClient();
      final userId = client.auth.currentUser?.id;

      if (userId == null) {
        return Result.error(ErrorModel('User not logged in'));
      }

      final response = await service.getMonthlyOverview(
        year: month.year,
        month: month.month,
      );
      
      if (response == null) {
        return Result.success(_createEmptyOverview());
      }

      return Result.success(
        _mapResponseToOverview(response as Map<String, dynamic>),
      );
    } catch (e) {
      return Result.error(ErrorModel(e.toString()));
    }
  }

  MonthlyOverview _mapResponseToOverview(Map<String, dynamic> json) {
    final income = (json['income'] as num).toDouble();
    final expenses = (json['expenses'] as num).toDouble();
    final currency = json['currency'] as String? ?? 'IQD';

    final maxAmount = income > expenses ? income : expenses;
    final maxValue = _calculateMaxValue(maxAmount);
    final scaleLabels = _generateScaleLabels(maxValue);

    return MonthlyOverview(
      income: income,
      expenses: expenses,
      currency: currency,
      maxValue: maxValue,
      scaleLabels: scaleLabels,
    );
  }

  MonthlyOverview _createEmptyOverview({String currency = 'IQD'}) {
    final maxValue = _calculateMaxValue(0);
    return MonthlyOverview(
      income: 0,
      expenses: 0,
      currency: currency,
      maxValue: maxValue,
      scaleLabels: _generateScaleLabels(maxValue),
    );
  }

  double _calculateMaxValue(double maxAmount) {
    if (maxAmount <= 0) return 100000;

    final magnitude = maxAmount.toString().split('.')[0].length - 1;
    final base = _pow(10, magnitude).toDouble();
    return ((maxAmount / base).ceil() * base).toDouble();
  }

  int _pow(int base, int exponent) {
    int result = 1;
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }

  List<String> _generateScaleLabels(double maxValue) {
    final step = maxValue / 8;
    final labels = <String>[];

    for (int i = 0; i <= 8; i++) {
      final value = step * i;
      labels.add(_formatScaleValue(value));
    }

    return labels;
  }

  String _formatScaleValue(double value) {
    if (value == 0) return '0';
    if (value >= 1000000) {
      final millions = value / 1000000;
      return millions == millions.truncate()
          ? '${millions.truncate()}M'
          : '${millions.toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      final thousands = value / 1000;
      return thousands == thousands.truncate()
          ? '${thousands.truncate()}K'
          : '${thousands.toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }

  @override
  Future<Result<CategoriesBreakdown>> getCategoriesBreakDown({
    required DateTime date,
  }) async {
    try {
      final data = await service.getCategoriesBreakDown(
        year: date.year,
        month: date.month,
      );
      if (data == null) {
        return Result.success(
          CategoriesBreakdown(categories: [], totalSpend: 0.0),
        );
      }
      return Result.success(CategoriesBreakdown.fromJson(data));
    } catch (e) {
      return Result.error(ErrorModel(e.toString()));
    }
  }

  @override
  Future<Result<SpendingTrend>> getSpendingTrend({required DateTime month}) async {
    try {
      final data = await service.getSpendingTrend(
        year: month.year,
        month: month.month,
      );

      if (data == null || (data as List).isEmpty) {
        return Result.success(SpendingTrend(points: [], currency: 'IQD'));
      }

      final points = (data).map((item) {
        final map = item as Map<String, dynamic>;
        return SpendingTrendPoint(
          date: DateTime.parse(map['spend_date'] as String),
          amount: (map['total_amount'] as num).toDouble(),
        );
      }).toList();

      final currency = (data.first as Map<String, dynamic>)['currency'] as String? ?? 'IQD';

      return Result.success(SpendingTrend(points: points, currency: currency));
    } catch (e) {
      return Result.error(ErrorModel(e.toString()));
    }
  }
}

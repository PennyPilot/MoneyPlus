import '../../core/service/supabase_service.dart';
import '../../domain/entity/monthly_overview.dart';
import '../../domain/repository/statistics_repository.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final SupabaseService _supabaseService;

  StatisticsRepositoryImpl({required SupabaseService supabaseService})
      : _supabaseService = supabaseService;

  @override
  Future<MonthlyOverview?> getMonthlyOverview({required DateTime month}) async {
    try {
      final client = await _supabaseService.getClient();
      final userId = client.auth.currentUser?.id;

      if (userId == null) {
        return null;
      }

      // Call RPC function
      final response = await client.rpc(
        'get_monthly_overview',
        params: {
          'in_year': month.year,
          'in_month': month.month,
        },
      );

      if (response == null) {
        return _createEmptyOverview();
      }

      return _mapResponseToOverview(response as Map<String, dynamic>);
    } catch (e) {
      print('Error fetching monthly overview: $e');
      rethrow;
    }
  }

  MonthlyOverview _mapResponseToOverview(Map<String, dynamic> json) {
    final income = (json['income'] as num).toDouble();
    final expenses = (json['expenses'] as num).toDouble();
    final currency = json['currency'] as String? ?? 'IQD';

    // Calculate max value and scale labels
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
}
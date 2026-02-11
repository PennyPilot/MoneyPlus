
import '../../data/service/supabase_service.dart';
import '../../domain/entity/monthly_overview.dart';
import '../../domain/repository/statistics_repository.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final SupabaseService _supabaseService;

  StatisticsRepositoryImpl({required SupabaseService supabaseService})
      : _supabaseService = supabaseService;

  @override
  Future<MonthlyOverview?> getMonthlyOverview({required DateTime month}) async {
    final client = await _supabaseService.getClient();
   // final userId = client.auth.currentUser?.id;

    final userId = "cdc4f388-4c4a-4ab4-84b1-5076fbe759c9";
    if (userId == null) {
      return null;
    }


    // Get first and last day of the month
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    // Query transactions for the month
    final response = await client
        .from('transactions')
        .select('''
          amount,
          transaction_type,
          currency_id,
          currencies!inner(abbreviation, abbreviation_ar)
        ''')
        .eq('user_id', userId)
        .limit(100);

    /* .gte('created_at', startOfMonth.toIso8601String())
        .lte('created_at', endOfMonth.toIso8601String());*/

    final transactions = response as List<dynamic>;

    print('Total transactions found: ${transactions.length}');

    if (transactions.isEmpty) {
      return null;
    }

    // Calculate income and expenses
    // Assuming transaction_type: 1 = income, 2 = expense (adjust based on your schema)
    double totalIncome = 0;
    double totalExpenses = 0;
    String currency = 'IQD';

    for (final transaction in transactions) {
      final amount = (transaction['amount'] as num).toDouble();
      final type = transaction['transaction_type'] as int;

      // Get currency from first transaction
      if (transaction['currencies'] != null) {
        currency = transaction['currencies']['abbreviation'] ?? 'IQD';
      }

      if (type == 1) {
        // Income
        totalIncome += amount;
      } else {
        // Expense
        totalExpenses += amount;
      }
    }

    // Calculate max value and scale labels dynamically
    final maxAmount = totalIncome > totalExpenses ? totalIncome : totalExpenses;
    final maxValue = _calculateMaxValue(maxAmount);
    final scaleLabels = _generateScaleLabels(maxValue);

    return MonthlyOverview(
      income: totalIncome,
      expenses: totalExpenses,
      currency: currency,
      maxValue: maxValue,
      scaleLabels: scaleLabels,
    );
  }

  double _calculateMaxValue(double maxAmount) {
    if (maxAmount <= 0) return 100000;

    // Round up to nearest significant value
    final magnitude = maxAmount.toString().length - 1;
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
import 'package:moneyplus/domain/entity/currency.dart';

class BalanceStatus {
  final double currentBalance;
  final double monthIncome;
  final double monthExpense;
  final double savingSpendingPercentage;
  final Currency defaultCurrency;

  BalanceStatus({
    required this.currentBalance,
    required this.monthIncome,
    required this.monthExpense,
    required this.savingSpendingPercentage,
    required this.defaultCurrency,
  });

  factory BalanceStatus.fromJson(Map<String, dynamic> json) {
    final currencyData = json['default_currency'];
    final Map<String, dynamic> currencyMap;
    
    if (currencyData is Map<String, dynamic>) {
      currencyMap = currencyData;
    } else if (currencyData is List && currencyData.isNotEmpty) {
      currencyMap = currencyData.first as Map<String, dynamic>;
    } else {
      currencyMap = {};
    }

    return BalanceStatus(
      currentBalance: (json['current_balance'] as num? ?? 0).toDouble(),
      monthIncome: (json['month_income'] as num? ?? 0).toDouble(),
      monthExpense: (json['month_expense'] as num? ?? 0).toDouble(),
      savingSpendingPercentage: (json['saving_spending_percentage'] as num? ?? 0).toDouble(),
      defaultCurrency: Currency.fromJson(currencyMap),
    );
  }
}

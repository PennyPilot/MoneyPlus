import 'package:moneyplus/domain/entity/currency.dart';

class BalanceStatus {
  final double currentBalance;
  final double monthIncome;
  final double monthExpense;
  final Currency defaultCurrency;

  BalanceStatus({
    required this.currentBalance,
    required this.monthIncome,
    required this.monthExpense,
    required this.defaultCurrency,
  });

  factory BalanceStatus.fromJson(Map<String, dynamic> json) {
    return BalanceStatus(
      currentBalance: (json['current_balance'] as num).toDouble(),
      monthIncome: (json['month_income'] as num).toDouble(),
      monthExpense: (json['month_expense'] as num).toDouble(),
      defaultCurrency: Currency.fromJson(json['default_currency'] as Map<String, dynamic>),
    );
  }
}

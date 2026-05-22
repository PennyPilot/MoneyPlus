import 'package:flutter/cupertino.dart';
import 'package:moneyplus/domain/repository/model/currency_breakdown.dart';

@immutable
sealed class HomeState {
  const HomeState();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final int selectedMonth;
  final int selectedYear;
  final double currentBalance;
  final double currentSavingSpendingPercentage;
  final double totalMonthIncome;
  final double totalMonthExpense;
  final String currency;
  final List<CurrencyBreakdown> currencyBreakdown;

  const HomeLoaded({
    required this.currentBalance,
    required this.currentSavingSpendingPercentage,
    required this.totalMonthIncome,
    required this.totalMonthExpense,
    required this.currencyBreakdown,
    required this.currency,
    required this.selectedMonth,
    required this.selectedYear,
  });

  HomeLoaded copyWith({
    int? selectedMonth,
    int? selectedYear,
    double? currentBalance,
    double? currentSavingSpendingPercentage,
    double? totalMonthIncome,
    double? totalMonthExpense,
    String? currency,
    List<CurrencyBreakdown>? currencyBreakdown,
  }) {
    return HomeLoaded(
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
      currentBalance: currentBalance ?? this.currentBalance,
      currentSavingSpendingPercentage: currentSavingSpendingPercentage ?? this.currentSavingSpendingPercentage,
      totalMonthIncome: totalMonthIncome ?? this.totalMonthIncome,
      totalMonthExpense: totalMonthExpense ?? this.totalMonthExpense,
      currency: currency ?? this.currency,
      currencyBreakdown: currencyBreakdown ?? this.currencyBreakdown,
    );
  }
}

class HomeError extends HomeState {
  final String errorMessage;

  const HomeError({required this.errorMessage});
}

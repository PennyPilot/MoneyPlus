import 'package:flutter/cupertino.dart';
import '../models/CategoryExpense.dart';
import 'home_cubit.dart';

@immutable
sealed class HomeState {
  const HomeState();
}

class HomeLoading extends HomeState {
  final bool isLoading;

  const HomeLoading({required this.isLoading});
}

class HomeLoaded extends HomeState {
  final Month selectedMonth;
  final int selectedYear;
  final double currentBalance;
  final double currentSavingSpendingPercentage;
  final double totalMonthIncome;
  final double totalMonthExpense;
  final String currency;
  final List<CategoryExpense> topSpendingCategories;

  const HomeLoaded({
    required this.currentBalance,
    required this.currentSavingSpendingPercentage,
    required this.totalMonthIncome,
    required this.totalMonthExpense,
    required this.topSpendingCategories,
    required this.currency,
    required this.selectedMonth,
    required this.selectedYear,
  });

  HomeLoaded copyWith({
    Month? selectedMonth,
    int? selectedYear,
    double? currentBalance,
    double? currentSavingSpendingPercentage,
    double? totalMonthIncome,
    double? totalMonthExpense,
    String? currency,
    List<CategoryExpense>? topSpendingCategories,
  }) {
    return HomeLoaded(
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
      currentBalance: currentBalance ?? this.currentBalance,
      currentSavingSpendingPercentage: currentSavingSpendingPercentage ?? this.currentSavingSpendingPercentage,
      totalMonthIncome: totalMonthIncome ?? this.totalMonthIncome,
      totalMonthExpense: totalMonthExpense ?? this.totalMonthExpense,
      currency: currency ?? this.currency,
      topSpendingCategories: topSpendingCategories ?? this.topSpendingCategories,
    );
  }
}

class HomeError extends HomeState {
  final String errorMessage;

  const HomeError({required this.errorMessage});
}

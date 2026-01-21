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
}

class HomeError extends HomeState {
  final String errorMessage;

  const HomeError({required this.errorMessage});
}

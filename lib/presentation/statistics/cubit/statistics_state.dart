import 'package:flutter/cupertino.dart';
import '../../../core/errors/error_model.dart';
import '../../../domain/entity/categories_breakdown.dart';

enum StatisticsStatus { initial, loading, success, failure }

@immutable
class StatisticsState {
  final StatisticsStatus status;
  final ErrorModel? error;
  final CategoriesBreakdown? categoriesBreakdown;

  const StatisticsState({
    required this.status,
    this.error,
    this.categoriesBreakdown,
  });

  factory StatisticsState.initial() => const StatisticsState(status: StatisticsStatus.initial);

  StatisticsState copyWith({
    StatisticsStatus? status,
    ErrorModel? error,
    CategoriesBreakdown? categoriesBreakdown,
  }) {
    return StatisticsState(
      status: status ?? this.status,
      error: error ?? this.error,
      categoriesBreakdown: categoriesBreakdown ?? this.categoriesBreakdown,
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:moneyplus/core/errors/error_model.dart';
import 'package:moneyplus/domain/entity/category.dart';

enum CategoriesStatus { initial, loading, success, failure }

@immutable
class CategoriesState {
  final CategoriesStatus status;
  final ErrorModel? error;
  final List<Category> categories;

  const CategoriesState({
    required this.status,
    this.error,
    this.categories = const [],
  });

  factory CategoriesState.initial() =>
      const CategoriesState(status: CategoriesStatus.initial);

  CategoriesState copyWith({
    CategoriesStatus? status,
    ErrorModel? error,
    List<Category>? categories,
  }) {
    return CategoriesState(
      status: status ?? this.status,
      error: error,
      categories: categories ?? this.categories,
    );
  }
}

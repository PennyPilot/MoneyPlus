import 'dart:ffi';

import 'package:moneyplus/domain/entity/categories_breakdown.dart';
import 'package:moneyplus/domain/entity/transaction.dart';
import 'package:moneyplus/domain/entity/transaction_category.dart';
import 'package:moneyplus/domain/entity/transaction_type.dart';
import 'package:moneyplus/domain/repository/model/top_spending_category.dart';

import '../../core/errors/result.dart';

abstract class StatisticsRepository {
  Future<Result<CategoriesBreakdown>> getCategoriesBreakDown(DateTime date);
}

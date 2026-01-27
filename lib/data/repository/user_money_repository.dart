import 'package:moneyplus/data/repository/utils/pair_class.dart';
import 'package:moneyplus/data/service/supabase_service.dart';
import 'package:moneyplus/domain/entity/transaction_category.dart';
import 'package:moneyplus/domain/repository/model/month_enum.dart';
import 'package:moneyplus/domain/repository/model/top_spending_category.dart';
import 'package:moneyplus/domain/repository/user_money_repository.dart';

class UserRepositoryImpl implements UserMoneyRepository {
  final SupabaseService service;

  UserRepositoryImpl({required this.service});

  @override
  Future<double> getMonthExpense(Month month, int year) async {
    final client = await service.getClient();

    final transactionResponse = await client
        .from('transaction_type')
        .select('id')
        .eq('name', 'expense');

    if (transactionResponse.isEmpty) {
      return 0.0;
    }

    final transactionTypeId = transactionResponse[0]['id'] as int;

    final response = await client
        .from('transactions')
        .select('amount')
        .eq('transaction_type', '$transactionTypeId')
        .gte('created_at', DateTime(year, month.index + 1, 1).toIso8601String())
        .lt('created_at', DateTime(year, month.index + 2, 1).toIso8601String());

    double expense = 0.0;
    for (final row in response) {
      expense += (row['amount'] as num).toDouble();
    }
    return expense;
  }

  @override
  Future<double> getMonthIncome(Month month, int year) async {
    final client = await service.getClient();

    final transactionResponse = await client
        .from('transaction_type')
        .select('id')
        .eq('name', 'income');

    if (transactionResponse.isEmpty) {
      return 0.0;
    }

    final transactionTypeId = transactionResponse[0]['id'] as int;

    final response = await client
        .from('transactions')
        .select('amount')
        .eq('transaction_type', '$transactionTypeId')
        .gte('created_at', DateTime(year, month.index + 1, 1).toIso8601String())
        .lt('created_at', DateTime(year, month.index + 2, 1).toIso8601String());
    double income = 0.0;

    for (final row in response) {
      income += (row['amount'] as num).toDouble();
    }
    return income;
  }

  @override
  Future<double> getTotalBalance() async {
    final client = await service.getClient();
    final response = await client.from('users').select('current_balance');
    return response.firstOrNull?['current_balance'] as double? ?? 0;
  }

  @override
  Future<List<TopSpendingCategory>> getTopSpendingCategoriesInMonth(
    Month month,
    int year,
  ) async {
    final int topSpendingCount = 5;

    final response = await _getCategoriesAmount(month, year);

    if (response.isEmpty) {
      return [];
    }

    final totalsAndDuplicates = _getCategoriesTotalsAndDuplicates(response);
    final totals = totalsAndDuplicates.first;
    final duplicates = totalsAndDuplicates.second;
    final topSpendingCategoriesMap = _getTopSpendingCategoriesMap(topSpendingCount, totals);

    final topSpendingCategoriesIds = topSpendingCategoriesMap.keys.toList();
    final categoriesValues = topSpendingCategoriesMap.values.toList();
    final categoriesNumberOfTransaction = topSpendingCategoriesIds.map((id) {
      return duplicates[id] ?? 0;
    }).toList();
    final categoriesNames = await _getTopSpendingCategoriesNames(
      topSpendingCategoriesIds,
    );
    final percentages = duplicates.values.map((value) {
      return (value / response.length) * 100;
    }).toList();

    return _getTopSpendingCategories(
      topSpendingCategoriesIds: topSpendingCategoriesIds,
      categoriesNames: categoriesNames,
      categoriesNumberOfTransaction: categoriesNumberOfTransaction,
      categoriesValues: categoriesValues,
      percentages: percentages,
    );
  }

  Future<List<Map<String, dynamic>>> _getCategoriesAmount(
    Month month,
    int year,
  ) async {
    final client = await service.getClient();
    return await client
        .from('transactions')
        .select('category_id, amount')
        .gte('created_at', DateTime(year, month.index + 1, 1).toIso8601String())
        .lt('created_at', DateTime(year, month.index + 2, 1).toIso8601String());
  }

  Pair<Map<int, double>, Map<int, int>> _getCategoriesTotalsAndDuplicates(
    List<Map<String, dynamic>> response,
  ) {
    final Map<int, double> totals = {};
    final Map<int, int> duplicates = {};

    for (final row in response) {
      final id = row['category_id'] as int;
      final amount = (row['amount'] as num).toDouble();
      duplicates[id] = (duplicates[id] ?? 1) + 1;
      totals[id] = (totals[id] ?? 0) + amount;
    }

    return Pair(totals, duplicates);
  }

  Map<int, double> _getTopSpendingCategoriesMap(
    int count,
    Map<int, double> totals,
  ) {
    final sortedEntries = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topEntries = sortedEntries.take(count).toList();

    return {for (final entry in topEntries) entry.key: entry.value};
  }

  Future<List<String>> _getTopSpendingCategoriesNames(
    List<int> topSpendingCategoriesId,
  ) async {
    final client = await service.getClient();
    final categoriesResponse = await client
        .from('categories')
        .select('id, name')
        .inFilter('id', topSpendingCategoriesId);

    final categoryNameById = {
      for (final row in categoriesResponse)
        row['id'] as int: row['name'] as String,
    };

    return topSpendingCategoriesId
        .map((id) => categoryNameById[id] ?? 'N/A')
        .toList();
  }

  Future<List<TopSpendingCategory>> _getTopSpendingCategories({
    required List<int> topSpendingCategoriesIds,
    required List<String> categoriesNames,
    required List<int> categoriesNumberOfTransaction,
    required List<double> categoriesValues,
    required List<double> percentages,
  }) async {
    var topSpendingCategories = <TopSpendingCategory>[];
    final currency = await getCurrency();
    for (int i = 0; i < topSpendingCategoriesIds.length; i++) {
      topSpendingCategories.add(
        TopSpendingCategory(
          category: TransactionCategory(
            id: topSpendingCategoriesIds[i],
            name: categoriesNames[i],
          ),
          numberOfTransactions: categoriesNumberOfTransaction[i],
          total: categoriesValues[i],
          currency: currency,
          percentage: percentages[i],
        ),
      );
    }

    return topSpendingCategories;
  }

  @override
  Future<String> getCurrency() async {
    final client = await service.getClient();
    final response = await client.from('users').select('salary_currency');
    return response.firstOrNull?['salary_currency'] as String? ?? 'N/A';
  }

  @override
  Future<double> getSavingSpendingPercentage(Month month, int year) async {
    final isJanuary = month.index == 0;
    final previousMonth = Month.values[isJanuary ? 11 : month.index - 1];
    final previousYear = isJanuary ? year - 1 : year;

    final [
      currentIncome,
      currentExpense,
      previousIncome,
      previousExpense,
    ] = await Future.wait([
      getMonthIncome(month, year),
      getMonthExpense(month, year),
      getMonthIncome(previousMonth, previousYear),
      getMonthExpense(previousMonth, previousYear),
    ]);

    final currentMonthBalance = currentIncome - currentExpense;
    final previousMonthBalance = previousIncome - previousExpense;

    if (previousMonthBalance == 0) {
      return 100;
    }
    return ((currentMonthBalance - previousMonthBalance) / previousMonthBalance) * 100;
  }
}

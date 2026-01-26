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
    final response = await client
        .from('transactions')
        .select('amount')
        .eq('transaction_type', 'expense')
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

    final response = await client
        .from('transactions')
        .select('amount')
        .eq('transaction_type', 'income')
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

    final response = await client
        .from('transactions')
        .select('amount, transaction_type');

    double balance = 0.0;
    for (final row in response) {
      final amount = (row['amount'] as num).toDouble();
      final type = row['transaction_type'] as String;
      if (type == 'income') {
        balance += amount;
      } else if (type == 'expense') {
        balance -= amount;
      }
    }
    return balance;
  }

  @override
  Future<List<TopSpendingCategory>> getTopSpendingCategoriesInMonth(Month month, int year) async {
    // requires RPC function to get categories(category id) with total spending
    return getFakeTopSpendingCategories();
  }

  @override
  Future<String> getCurrency() async {
    // final client = await service.getClient();
    //
    // final response = await client
    //     .from('users')
    //     .select('currency');
    // return response[0]['currency'] as String;
    return 'EGY';
  }
}

List<TopSpendingCategory> getFakeTopSpendingCategories() {
  return [
    TopSpendingCategory(
      category: TransactionCategory(id: 1, name: "Food"),
      numberOfTransactions: 15,
      total: 10000,
      currency: "IRQ",
      percentage: 33.3,
    ),
    TopSpendingCategory(
      category: TransactionCategory(id: 2, name: "Transport"),
      numberOfTransactions: 10,
      total: 5000,
      currency: "EGY",
      percentage: 16.7,
    ),
    TopSpendingCategory(
      category: TransactionCategory(id: 3, name: "Entertainment"),
      numberOfTransactions: 8,
      total: 3000,
      currency: "EGY",
      percentage: 10.0,
    ),
  ];
}

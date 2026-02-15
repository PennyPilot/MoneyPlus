import '../../../domain/entity/transaction.dart';
import '../../../domain/entity/transaction_category.dart';
import '../../../domain/entity/transaction_type.dart';
import '../../../domain/repository/model/top_spending_category.dart';

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

final fakeTransactionExpense = Transaction(
  id: 1,
  amount: 128.50,
  currency: "USD",
  type: TransactionType.expense,
  date: DateTime.now(),
  category: TransactionCategory(
    id: 101,
    name: "Food & Drinks",
  ),
  note: "Lunch at café",
);

final fakeTransactionIncome = Transaction(
  id: 2,
  amount: 500.00,
  currency: "USD",
  type: TransactionType.income,
  date: DateTime.now(),
  category: TransactionCategory(
    id: 201,
    name: "Salary",
  ),
  note: "Monthly paycheck",
);
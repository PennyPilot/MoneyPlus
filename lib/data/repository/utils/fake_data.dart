import '../../../domain/entity/transaction_category.dart';
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
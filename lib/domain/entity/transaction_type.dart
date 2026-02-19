enum TransactionType {
  income,
  expense;

  factory TransactionType.fromInt(int value) {
    switch (value) {
      case 1:
        return TransactionType.income;
      case 2:
        return TransactionType.expense;
      default:
        throw ArgumentError("Invalid transaction type value: $value");
    }
  }

  int get value {
    switch (this) {
      case TransactionType.income:
        return 1;
      case TransactionType.expense:
        return 2;
    }
  }
}
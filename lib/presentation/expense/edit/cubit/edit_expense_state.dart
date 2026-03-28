import 'package:equatable/equatable.dart';
import 'package:moneyplus/domain/entity/currency.dart';

import '../../../../../domain/entity/transaction_category.dart';
import '../../../../../domain/model/form_status.dart';

class EditExpenseState extends Equatable {
  final String transactionId;
  final double? amount;
  final DateTime date;
  final String note;
  final Currency? currency;
  final FormStatus status;
  final String? errorMessage;

  final List<TransactionCategory> categories;
  final TransactionCategory? selectedCategory;
  final bool isLoadingCategories;
  final bool isLoadingTransaction;

  bool get canSubmitForm =>
      amount != null &&
      amount! > 0 &&
      status != FormStatus.loading &&
      !isLoadingTransaction;

  const EditExpenseState({
    required this.transactionId,
    this.amount,
    required this.date,
    this.note = '',
    this.currency,
    required this.status,
    this.errorMessage,
    this.categories = const [],
    this.selectedCategory,
    this.isLoadingCategories = false,
    this.isLoadingTransaction = false,
  });

  factory EditExpenseState.initial({required String transactionId}) {
    return EditExpenseState(
      transactionId: transactionId,
      date: DateTime.now(),
      status: FormStatus.initial,
    );
  }

  EditExpenseState copyWith({
    String? transactionId,
    double? amount,
    DateTime? date,
    String? note,
    Currency? currency,
    FormStatus? status,
    String? errorMessage,
    List<TransactionCategory>? categories,
    TransactionCategory? selectedCategory,
    bool? isLoadingCategories,
    bool? isLoadingTransaction,
    bool clearAmount = false,
    bool clearError = false,
  }) {
    return EditExpenseState(
      transactionId: transactionId ?? this.transactionId,
      amount: clearAmount ? null : (amount ?? this.amount),
      date: date ?? this.date,
      note: note ?? this.note,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      isLoadingTransaction: isLoadingTransaction ?? this.isLoadingTransaction,
    );
  }

  @override
  List<Object?> get props => [
    transactionId,
    amount,
    date,
    note,
    currency,
    status,
    errorMessage,
    categories,
    selectedCategory,
    isLoadingCategories,
    isLoadingTransaction,
  ];
}

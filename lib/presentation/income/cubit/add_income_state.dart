import 'package:equatable/equatable.dart';
import 'package:moneyplus/domain/model/form_status.dart';

import '../../../domain/entity/currency.dart';
import '../../../domain/entity/transaction_category.dart';

class AddIncomeState extends Equatable {
  final double? amount;
  final DateTime date;
  final String note;
  final Currency? currency;
  final FormStatus status;
  final String? errorMessage;

  final List<TransactionCategory> categories;
  final TransactionCategory? selectedCategory;
  final bool isLoadingCategories;

  bool get canSubmitForm => amount != null && amount! > 0 && status != FormStatus.loading;

  const AddIncomeState({
    this.amount,
    required this.date,
    this.note = '',
    this.currency,
    required this.status,
    this.errorMessage,
    this.categories = const [],
    this.selectedCategory,
    this.isLoadingCategories = false,
  });

  factory AddIncomeState.initial() {
    return AddIncomeState(date: DateTime.now(), status: FormStatus.initial);
  }

  AddIncomeState copyWith({
    double? amount,
    DateTime? date,
    String? note,
    Currency? currency,
    FormStatus? status,
    String? errorMessage,
    List<TransactionCategory>? categories,
    TransactionCategory? selectedCategory,
    bool? isLoadingCategories,
    bool clearAmount = false,
  }) {
    return AddIncomeState(
      amount: clearAmount ? null : (amount ?? this.amount),
      date: date ?? this.date,
      note: note ?? this.note,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
    );
  }

  @override
  List<Object?> get props => [
    amount,
    date,
    note,
    currency,
    status,
    errorMessage,
    categories,
    selectedCategory,
    isLoadingCategories,
  ];
}

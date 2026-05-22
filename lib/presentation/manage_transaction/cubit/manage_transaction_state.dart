import 'package:equatable/equatable.dart';
import 'package:moneyplus/domain/entity/currency.dart';
import 'package:moneyplus/domain/entity/transaction_category.dart';
import 'package:moneyplus/domain/entity/transaction_type.dart';
import 'package:moneyplus/domain/model/form_status.dart';
import 'package:moneyplus/domain/repository/model/currency_rate.dart';

class ManageTransactionState extends Equatable {
  final TransactionType transactionType;
  final double? amount;
  final DateTime date;
  final String note;
  final Currency? currency;
  final FormStatus status;
  final String? errorMessage;
  final List<TransactionCategory> categories;
  final TransactionCategory? selectedCategory;
  final bool isLoadingCategories;
  final bool isEditing;
  final String? transactionId;

  final List<Currency> currencies;
  final List<Currency> filteredCurrencies;
  final String currencyQuery;
  final bool isLoadingCurrencies;
  final bool isFirstTransaction;
  final List<CurrencyRate> exchangeRates;

  const ManageTransactionState({
    required this.transactionType,
    this.amount,
    required this.date,
    this.note = '',
    this.currency,
    required this.status,
    this.errorMessage,
    this.categories = const [],
    this.selectedCategory,
    this.isLoadingCategories = false,
    this.isEditing = false,
    this.transactionId,
    this.currencies = const [],
    this.filteredCurrencies = const [],
    this.currencyQuery = '',
    this.isLoadingCurrencies = false,
    this.isFirstTransaction = false,
    this.exchangeRates = const [],
  });

  bool get canSubmitForm =>
      amount != null && amount! > 0 && selectedCategory != null && currency != null && status != FormStatus.loading;

  factory ManageTransactionState.initial(TransactionType type) {
    return ManageTransactionState(
      transactionType: type,
      date: DateTime.now(),
      status: FormStatus.initial,
    );
  }

  ManageTransactionState copyWith({
    TransactionType? transactionType,
    double? amount,
    DateTime? date,
    String? note,
    Currency? currency,
    FormStatus? status,
    String? errorMessage,
    List<TransactionCategory>? categories,
    TransactionCategory? selectedCategory,
    bool? isLoadingCategories,
    bool? isEditing,
    String? transactionId,
    bool clearAmount = false,
    List<Currency>? currencies,
    List<Currency>? filteredCurrencies,
    String? currencyQuery,
    bool? isLoadingCurrencies,
    bool? isFirstTransaction,
    List<CurrencyRate>? exchangeRates,
  }) {
    return ManageTransactionState(
      transactionType: transactionType ?? this.transactionType,
      amount: clearAmount ? null : (amount ?? this.amount),
      date: date ?? this.date,
      note: note ?? this.note,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      isEditing: isEditing ?? this.isEditing,
      transactionId: transactionId ?? this.transactionId,
      currencies: currencies ?? this.currencies,
      filteredCurrencies: filteredCurrencies ?? this.filteredCurrencies,
      currencyQuery: currencyQuery ?? this.currencyQuery,
      isLoadingCurrencies: isLoadingCurrencies ?? this.isLoadingCurrencies,
      isFirstTransaction: isFirstTransaction ?? this.isFirstTransaction,
      exchangeRates: exchangeRates ?? this.exchangeRates,
    );
  }

  @override
  List<Object?> get props => [
        transactionType,
        amount,
        date,
        note,
        currency,
        status,
        errorMessage,
        categories,
        selectedCategory,
        isLoadingCategories,
        isEditing,
        transactionId,
        currencies,
        filteredCurrencies,
        currencyQuery,
        isLoadingCurrencies,
        isFirstTransaction,
        exchangeRates,
      ];
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/domain/entity/currency.dart';
import 'package:moneyplus/domain/entity/transaction_category.dart';
import 'package:moneyplus/domain/entity/transaction_type.dart';
import 'package:moneyplus/domain/model/form_status.dart';
import 'package:moneyplus/domain/repository/account_repository.dart';
import 'package:moneyplus/domain/repository/transaction_repository.dart';
import 'package:moneyplus/domain/repository/user_money_repository.dart';
import 'manage_transaction_state.dart';

class ManageTransactionCubit extends Cubit<ManageTransactionState> {
  final TransactionRepository _transactionRepository;
  final UserMoneyRepository _userMoneyRepository;
  final AccountRepository _accountRepository;

  ManageTransactionCubit({
    required TransactionRepository transactionRepository,
    required UserMoneyRepository userMoneyRepository,
    required AccountRepository accountRepository,
    required TransactionType initialType,
    String? transactionId,
  })  : _transactionRepository = transactionRepository,
        _userMoneyRepository = userMoneyRepository,
        _accountRepository = accountRepository,
        super(ManageTransactionState.initial(initialType).copyWith(
          transactionId: transactionId,
          isEditing: transactionId != null,
          status: FormStatus.initial,
        )) {
    _init();
  }

  Future<void> _init() async {
    await fetchCurrencies();
    await _loadCurrency();
    if (state.isEditing) {
      await _loadTransaction();
    } else {
      await _loadCategories(state.transactionType);
    }
    await _loadExchangeRates();
  }

  Future<void> _loadTransaction() async {
    if (state.transactionId == null) return;
    
    emit(state.copyWith(status: FormStatus.loading));
    final result = await _transactionRepository.getTransactionDetails(state.transactionId!.toString());
    
    result.when(
      onSuccess: (transaction) async {
        final transactionCurrency = state.currencies
            .where((c) => c.abbreviation == transaction.currency)
            .firstOrNull;
            
        emit(state.copyWith(
          amount: transaction.amount,
          date: transaction.date,
          note: transaction.note,
          transactionType: transaction.type,
          currency: transactionCurrency,
        ));
        await _loadCategories(transaction.type, selectedCategoryId: transaction.category.id);
        emit(state.copyWith(status: FormStatus.initial));
      },
      onError: (error) {
        emit(state.copyWith(
          status: FormStatus.failure,
          errorMessage: "Failed to load transaction.",
        ));
      },
    );
  }

  Future<void> _loadCategories(TransactionType type, {int? selectedCategoryId}) async {
    emit(state.copyWith(isLoadingCategories: true));
    final result = await _transactionRepository.getTransactionCategories(type: type);

    result.when(
      onSuccess: (categories) {
        final selectedCategory = selectedCategoryId != null 
            ? categories.where((c) => c.id == selectedCategoryId).firstOrNull 
            : categories.firstOrNull;
            
        emit(state.copyWith(
          categories: categories,
          selectedCategory: selectedCategory,
          isLoadingCategories: false,
          transactionType: type,
        ));
      },
      onError: (error) {
        emit(state.copyWith(
          isLoadingCategories: false,
          status: FormStatus.failure,
          errorMessage: "Failed to load categories.",
        ));
      },
    );
  }

  Future<void> _loadCurrency() async {
    try {
      final currency = await _userMoneyRepository.getCurrency();
      if (currency.abbreviation.isEmpty) {
        emit(state.copyWith(isFirstTransaction: true));
      } else {
        emit(state.copyWith(
          currency: currency,
          isFirstTransaction: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(isFirstTransaction: true));
    }
  }

  Future<void> fetchCurrencies() async {
    emit(state.copyWith(isLoadingCurrencies: true));
    try {
      final currencies = await _accountRepository.getCurrencies();
      emit(state.copyWith(
        currencies: currencies,
        filteredCurrencies: currencies,
        isLoadingCurrencies: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoadingCurrencies: false));
    }
  }

  void onCurrencySearchChanged(String query) {
    final filtered = state.currencies
        .where((currency) =>
            currency.name.toLowerCase().contains(query.toLowerCase()) ||
            currency.abbreviation.toLowerCase().contains(query.toLowerCase()))
        .toList();

    emit(state.copyWith(
      currencyQuery: query,
      filteredCurrencies: filtered,
    ));
  }

  void onCurrencyChanged(Currency currency) {
    emit(state.copyWith(currency: currency));
    _loadExchangeRates();
  }

  void onAmountChanged(String value) {
    if (value.trim().isEmpty) {
      emit(state.copyWith(clearAmount: true));
      return;
    }
    final parsed = double.tryParse(value);
    emit(state.copyWith(amount: parsed, clearAmount: false));
  }

  void onDateChanged(DateTime newDate) {
    emit(state.copyWith(date: newDate));
    _loadExchangeRates();
  }

  Future<void> _loadExchangeRates() async {
    if (state.currency == null) return;
    try {
      final rates = await _transactionRepository.getExchangeRate(
        baseCurrencyId: state.currency!.id,
        date: state.date,
      );
      emit(state.copyWith(exchangeRates: rates));
    } catch (e) {
    }
  }

  void onNoteChanged(String newNote) {
    emit(state.copyWith(note: newNote));
  }

  void onCategorySelected(TransactionCategory category) {
    emit(state.copyWith(selectedCategory: category));
  }

  Future<void> submit() async {
    if (!state.canSubmitForm) return;

    emit(state.copyWith(status: FormStatus.loading));
    try {
      final result = await _transactionRepository.upsertTransaction(
        id: state.isEditing ? state.transactionId : null,
        amount: state.amount!,
        type: state.transactionType,
        date: state.date,
        category: state.selectedCategory!,
        currency: state.currency!,
        note: state.note,
      );

      await result.when(
        onSuccess: (_) async {
          if (!state.isEditing && state.isFirstTransaction) {
            await _accountRepository.updateCurrency(state.currency!.id);
          }
          emit(state.copyWith(status: FormStatus.success));
        },
        onError: (error) {
          emit(state.copyWith(
            status: FormStatus.failure,
            errorMessage: state.isEditing ? "Failed to update transaction." : "Failed to add transaction.",
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: FormStatus.failure,
        errorMessage: "An unexpected error occurred.",
      ));
    }
  }
}

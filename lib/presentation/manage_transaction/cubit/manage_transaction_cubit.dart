import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/domain/entity/transaction_category.dart';
import 'package:moneyplus/domain/entity/transaction_type.dart';
import 'package:moneyplus/domain/model/form_status.dart';
import 'package:moneyplus/domain/repository/transaction_repository.dart';
import 'package:moneyplus/domain/repository/user_money_repository.dart';
import 'manage_transaction_state.dart';

class ManageTransactionCubit extends Cubit<ManageTransactionState> {
  final TransactionRepository _transactionRepository;
  final UserMoneyRepository _userMoneyRepository;

  ManageTransactionCubit({
    required TransactionRepository transactionRepository,
    required UserMoneyRepository userMoneyRepository,
    required TransactionType initialType,
    String? transactionId,
  })  : _transactionRepository = transactionRepository,
        _userMoneyRepository = userMoneyRepository,
        super(ManageTransactionState.initial(initialType).copyWith(
          transactionId: transactionId,
          isEditing: transactionId != null,
          status: FormStatus.loading,
        )) {
    _init();
  }

  Future<void> _init() async {
    await _loadCurrency();
    if (state.isEditing) {
      await _loadTransaction();
    } else {
      await _loadCategories(state.transactionType);
    }
  }

  Future<void> _loadTransaction() async {
    if (state.transactionId == null) return;
    
    emit(state.copyWith(status: FormStatus.loading));
    final result = await _transactionRepository.getTransactionDetails(state.transactionId!.toString());
    
    result.when(
      onSuccess: (transaction) async {
        emit(state.copyWith(
          amount: transaction.amount,
          date: transaction.date,
          note: transaction.note,
          transactionType: transaction.type,
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
      emit(state.copyWith(currency: currency));
    } catch (e) {
      // Handle error or ignore if not critical
    }
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
      if (state.isEditing) {
        final success = await _transactionRepository.editTransaction(
          id: state.transactionId!,
          amount: state.amount!,
          type: state.transactionType,
          date: state.date,
          category: state.selectedCategory!,
          note: state.note,
        );
        if (success) {
          emit(state.copyWith(status: FormStatus.success));
        } else {
          emit(state.copyWith(
            status: FormStatus.failure,
            errorMessage: "Failed to update transaction.",
          ));
        }
      } else {
        final result = await _transactionRepository.addTransaction(
          amount: state.amount!,
          type: state.transactionType,
          date: state.date,
          category: state.selectedCategory!,
          currency: state.currency!,
          note: state.note,
        );

        result.when(
          onSuccess: (_) {
            emit(state.copyWith(status: FormStatus.success));
          },
          onError: (error) {
            emit(state.copyWith(
              status: FormStatus.failure,
              errorMessage: "Failed to add transaction.",
            ));
          },
        );
      }
    } catch (e) {
      emit(state.copyWith(
        status: FormStatus.failure,
        errorMessage: "An unexpected error occurred.",
      ));
    }
  }
}

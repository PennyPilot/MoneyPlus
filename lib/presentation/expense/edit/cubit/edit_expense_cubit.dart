import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/domain/entity/transaction_category.dart';
import 'package:moneyplus/domain/entity/transaction_type.dart';
import 'package:moneyplus/domain/model/form_status.dart';

import '../../../../../domain/repository/transaction_repository.dart';
import '../../../../../domain/repository/user_money_repository.dart';
import 'edit_expense_state.dart';

class EditExpenseCubit extends Cubit<EditExpenseState> {
  final TransactionRepository _transactionRepository;
  final UserMoneyRepository _userMoneyRepository;

  EditExpenseCubit({
    required TransactionRepository transactionRepository,
    required UserMoneyRepository userMoneyRepository,
    required String transactionId,
  }) : _transactionRepository = transactionRepository,
        _userMoneyRepository = userMoneyRepository,
        super(EditExpenseState.initial(transactionId: transactionId)) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([_loadCurrency(), _loadCategories()]);
    await _loadTransaction();
  }

  Future<void> _loadCategories() async {
    emit(state.copyWith(isLoadingCategories: true));
    final result = await _transactionRepository.getTransactionCategories(
      type: TransactionType.expense,
    );

    result.when(
      onSuccess: (categories) {
        emit(state.copyWith(categories: categories, isLoadingCategories: false));
      },
      onError: (error) {
        emit(
          state.copyWith(
            isLoadingCategories: false,
            status: FormStatus.failure,
            errorMessage: "Failed to load categories.",
          ),
        );
      },
    );
  }

  Future<void> _loadCurrency() async {
    try {
      final currency = await _userMoneyRepository.getCurrency();
      emit(state.copyWith(currency: currency));
    } catch (e) {
      emit(
        state.copyWith(
          status: FormStatus.failure,
          errorMessage: "Failed to load currency.",
        ),
      );
    }
  }

  Future<void> _loadTransaction() async {
    emit(state.copyWith(isLoadingTransaction: true));

    final result = await _transactionRepository.getTransactionDetails(
      state.transactionId,
    );

    result.when(
      onSuccess: (transaction) {
        final matchedCategory = state.categories.firstWhere(
              (c) => c.id == transaction.category.id,
          orElse: () => transaction.category,
        );

        emit(
          state.copyWith(
            amount: transaction.amount,
            date: transaction.date,
            note: transaction.note,
            selectedCategory: matchedCategory,
            isLoadingTransaction: false,
            status: FormStatus.initial,
          ),
        );
      },
      onError: (error) {
        emit(
          state.copyWith(
            isLoadingTransaction: false,
            status: FormStatus.failure,
            errorMessage: "Failed to load expense details.",
          ),
        );
      },
    );
  }

  void onAmountChanged(String value) {
    if (value.trim().isEmpty) {
      emit(state.copyWith(clearAmount: true));
      return;
    }

    final parsed = double.tryParse(value);
    emit(state.copyWith(amount: parsed));
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

  Future<void> onSubmitExpense() async {
    if (!state.canSubmitForm) return;

    emit(state.copyWith(status: FormStatus.loading, clearError: true));

    try {
      final result = await _transactionRepository.editTransaction(
        id: state.transactionId,
        amount: state.amount,
        type: TransactionType.expense,
        date: state.date,
        category: state.selectedCategory,
        note: state.note,
      );

      result.when(
        onSuccess: (_) {
          emit(state.copyWith(status: FormStatus.success));
        },
        onError: (error) {
          emit(
            state.copyWith(
              status: FormStatus.failure,
              errorMessage: "Failed to update expense.",
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FormStatus.failure,
          errorMessage: "An unexpected error occurred.",
        ),
      );
    }
  }

  Future<void> onDeleteExpense() async {
    emit(state.copyWith(status: FormStatus.loading, clearError: true));

    try {
      final result = await _transactionRepository.deleteTransaction(
        state.transactionId,
      );

      result.when(
        onSuccess: (_) {
          emit(state.copyWith(status: FormStatus.success));
        },
        onError: (error) {
          emit(
            state.copyWith(
              status: FormStatus.failure,
              errorMessage: "Failed to delete expense.",
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FormStatus.failure,
          errorMessage: "An unexpected error occurred.",
        ),
      );
    }
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/domain/entity/transaction_category.dart';
import 'package:moneyplus/domain/entity/transaction_type.dart';
import 'package:moneyplus/domain/model/form_status.dart';

import '../../../domain/repository/transaction_repository.dart';
import '../../../domain/repository/user_money_repository.dart';
import 'add_expense_state.dart';

class AddExpenseCubit extends Cubit<AddExpenseState> {
  final TransactionRepository _transactionRepository;
  final UserMoneyRepository _userMoneyRepository;

  AddExpenseCubit({
    required TransactionRepository transactionRepository,
    required UserMoneyRepository userMoneyRepository,
  }) : _transactionRepository = transactionRepository,
       _userMoneyRepository = userMoneyRepository,
       super(AddExpenseState.initial()) {
    _loadCurrency();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    emit(state.copyWith(isLoadingCategories: true));
    final transactionCategories = await _transactionRepository.getTransactionCategories(
      type: TransactionType.expense,
    );

    transactionCategories.when(
      onSuccess: (categories) {
        emit(
          state.copyWith(
            categories: categories,
            selectedCategory: categories.firstOrNull,
            isLoadingCategories: false,
          ),
        );
      },
      onError: (error) {
        emit(
          state.copyWith(
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
          errorMessage: "Failed to load currency",
        ),
      );
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

  Future<void> onSubmitExpense() async {
    if (!state.canSubmitForm) return;

    emit(state.copyWith(status: FormStatus.loading));
    try {
      final result = await _transactionRepository.upsertTransaction(
        amount: state.amount!,
        type: TransactionType.expense,
        date: state.date,
        category: state.selectedCategory!,
        currency: state.currency!,
        note: state.note,
      );

      result.when(
        onSuccess: (user) {
          emit(state.copyWith(status: FormStatus.success));
        },
        onError: (error) {
          emit(
            state.copyWith(
              status: FormStatus.failure,
              errorMessage: "Failed to add expense.",
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
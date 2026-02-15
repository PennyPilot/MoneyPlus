import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/domain/entity/transaction_category.dart';
import 'package:moneyplus/domain/entity/transaction_type.dart';
import 'package:moneyplus/domain/model/form_status.dart';
import 'package:moneyplus/domain/repository/transaction_repository.dart';
import 'package:moneyplus/presentation/income/cubit/add_income_state.dart';

class AddIncomeCubit extends Cubit<AddIncomeState> {
  final TransactionRepository _repository;

  AddIncomeCubit({required TransactionRepository repository})
    : _repository = repository,
      super(AddIncomeState.initial()) {
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    emit(state.copyWith(isLoadingCategories: true));
    final categories = <TransactionCategory>[
      TransactionCategory(id: 1, name: 'Salary'),
      TransactionCategory(id: 2, name: 'Freelance'),
      TransactionCategory(id: 3, name: 'Treasure'),
    ];

    emit(
      state.copyWith(
        categories: categories,
        selectedCategory: categories.first,
        isLoadingCategories: false,
      ),
    );
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

  Future<void> onSubmitIncome(String categoryName) async {
    if (!state.canSubmitForm) return;

    emit(state.copyWith(status: FormStatus.loading));

    try {
      final category =
          state.selectedCategory ??
          TransactionCategory(id: 1, name: categoryName);

      final success = await _repository.addTransaction(
        amount: state.amount!,
        type: TransactionType.income,
        date: state.date,
        category: category,
        note: state.note,
      );

      if (success) {
        emit(state.copyWith(status: FormStatus.success));
      } else {
        emit(state.copyWith(status: FormStatus.failure));
      }
    } catch (e) {
      emit(
        state.copyWith(status: FormStatus.failure, errorMessage: e.toString()),
      );
    }
  }
}

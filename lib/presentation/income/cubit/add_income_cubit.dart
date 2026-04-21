import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/domain/model/form_status.dart';
import 'package:moneyplus/domain/repository/transaction_repository.dart';
import 'package:moneyplus/presentation/income/cubit/add_income_state.dart';

import '../../../domain/repository/user_money_repository.dart';

class AddIncomeCubit extends Cubit<AddIncomeState> {
  final TransactionRepository _transactionRepository;
  final UserMoneyRepository _userMoneyRepository;

  AddIncomeCubit({
    required TransactionRepository transactionRepository,
    required UserMoneyRepository userMoneyRepository,
  }) : _transactionRepository = transactionRepository,
       _userMoneyRepository = userMoneyRepository,
       super(AddIncomeState.initial()) {
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    try {
      emit(state.copyWith(status: FormStatus.loading));
      final currency = await _userMoneyRepository.getCurrency();

      emit(state.copyWith(currency: currency, status: FormStatus.initial));
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

  Future<void> onSubmitIncome() async {
    if (!state.canSubmitForm) return;

    emit(state.copyWith(status: FormStatus.loading));
    try {
      final result = await _transactionRepository.addIncomeTransaction(
        amount: state.amount!,
        date: state.date,
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
              errorMessage: "Failed to add income: ${error.message}",
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FormStatus.failure,
          errorMessage: "An unexpected error occurred: $e",
        ),
      );
    }
  }
}
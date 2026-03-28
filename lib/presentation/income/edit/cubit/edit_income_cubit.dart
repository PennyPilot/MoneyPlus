import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/domain/entity/transaction_type.dart';
import 'package:moneyplus/domain/model/form_status.dart';
import 'package:moneyplus/domain/repository/transaction_repository.dart';

import '../../../../../domain/repository/user_money_repository.dart';
import 'edit_income_state.dart';

class EditIncomeCubit extends Cubit<EditIncomeState> {
  final TransactionRepository _transactionRepository;
  final UserMoneyRepository _userMoneyRepository;

  EditIncomeCubit({
    required TransactionRepository transactionRepository,
    required UserMoneyRepository userMoneyRepository,
    required String transactionId,
  }) : _transactionRepository = transactionRepository,
       _userMoneyRepository = userMoneyRepository,
       super(EditIncomeState.initial(transactionId: transactionId)) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([_loadCurrency(), _loadTransaction()]);
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
        emit(
          state.copyWith(
            amount: transaction.amount,
            date: transaction.date,
            note: transaction.note,
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
            errorMessage: "Failed to load income details.",
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

  Future<void> onSubmitIncome() async {
    if (!state.canSubmitForm) return;

    emit(state.copyWith(status: FormStatus.loading));

    try {
      final result = await _transactionRepository.editTransaction(
        id: state.transactionId,
        amount: state.amount,
        type: TransactionType.income,
        date: state.date,
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
              errorMessage: "Failed to update income.",
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

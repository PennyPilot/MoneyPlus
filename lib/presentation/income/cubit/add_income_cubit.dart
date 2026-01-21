import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/domain/entity/transaction_category.dart';
import 'package:moneyplus/domain/entity/transaction_type.dart';
import 'package:moneyplus/domain/model/form_status.dart';
import 'package:moneyplus/domain/repository/transaction_repository.dart';
import 'package:moneyplus/presentation/income/cubit/add_income_state.dart';

class AddIncomeCubit extends Cubit<AddIncomeState> {
  final TransactionRepository _repository;
  
  AddIncomeCubit({
    required TransactionRepository repository,
  })  : _repository = repository,
        super(AddIncomeState.initial());
  
  void amountChanged(String value) {
    final parsed = double.tryParse(value);
    emit(state.copyWith(amount: parsed));
  }
  
  void dateChanged(DateTime newDate) {
    emit(state.copyWith(date: newDate));
  }
  
  void noteChanged(String newNote) {
    emit(state.copyWith(note: newNote));
  }
  
  Future<void> submitIncome(String categoryName) async {
    if (!state.isFormValid) return;
    
    emit(state.copyWith(status: FormStatus.loading));
    
    try {
      final defaultCategory = TransactionCategory(id: 1, name: categoryName);
      
      final success = await _repository.addTransaction(
        amount: state.amount!,
        type: TransactionType.income,
        date: state.date,
        category: defaultCategory,
        note: state.note,
      );
      
      if (success) {
        emit(state.copyWith(status: FormStatus.success));
      } else {
        emit(state.copyWith(status: FormStatus.failure));
      }
    } catch (e) {
      emit(state.copyWith(
        status: FormStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}

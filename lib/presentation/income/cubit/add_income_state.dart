import 'package:equatable/equatable.dart';
import 'package:moneyplus/domain/model/form_status.dart';

class AddIncomeState extends Equatable {
  final double? amount;
  final DateTime date;
  final String note;
  final FormStatus status;
  final String? errorMessage;
  
  bool get isFormValid => amount != null && amount! > 0;
  
  const AddIncomeState({
    this.amount,
    required this.date,
    this.note = '',
    required this.status,
    this.errorMessage,
  });
  
  factory AddIncomeState.initial() {
    return AddIncomeState(
      date: DateTime.now(),
      status: FormStatus.initial,
    );
  }
  
  AddIncomeState copyWith({
    double? amount,
    DateTime? date,
    String? note,
    FormStatus? status,
    String? errorMessage,
  }) {
    return AddIncomeState(
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
  
  @override
  List<Object?> get props => [amount, date, note, status, errorMessage];
}

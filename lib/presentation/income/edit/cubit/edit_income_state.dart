import 'package:equatable/equatable.dart';
import 'package:moneyplus/domain/model/form_status.dart';

import '../../../../domain/entity/currency.dart';

class EditIncomeState extends Equatable {
  final String transactionId;
  final double? amount;
  final DateTime date;
  final String note;
  final Currency? currency;
  final FormStatus status;
  final String? errorMessage;
  final bool isLoadingTransaction;

  bool get canSubmitForm =>
      amount != null &&
      amount! > 0 &&
      status != FormStatus.loading &&
      !isLoadingTransaction;

  const EditIncomeState({
    required this.transactionId,
    this.amount,
    required this.date,
    this.note = '',
    this.currency,
    required this.status,
    this.errorMessage,
    this.isLoadingTransaction = false,
  });

  factory EditIncomeState.initial({required String transactionId}) {
    return EditIncomeState(
      transactionId: transactionId,
      date: DateTime.now(),
      status: FormStatus.initial,
    );
  }

  EditIncomeState copyWith({
    String? transactionId,
    double? amount,
    DateTime? date,
    String? note,
    Currency? currency,
    FormStatus? status,
    String? errorMessage,
    bool? isLoadingTransaction,
    bool clearAmount = false,
  }) {
    return EditIncomeState(
      transactionId: transactionId ?? this.transactionId,
      amount: clearAmount ? null : (amount ?? this.amount),
      date: date ?? this.date,
      note: note ?? this.note,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoadingTransaction: isLoadingTransaction ?? this.isLoadingTransaction,
    );
  }

  @override
  List<Object?> get props => [
    transactionId,
    amount,
    date,
    note,
    currency,
    status,
    errorMessage,
    isLoadingTransaction,
  ];
}

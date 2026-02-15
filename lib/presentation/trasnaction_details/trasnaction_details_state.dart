part of 'trasnaction_details_cubit.dart';

@immutable
sealed class TransactionDetailsState {}

final class TransactionDetailsLoading extends TransactionDetailsState {}

final class TransactionDetailsLoaded extends TransactionDetailsState {
  final Transaction transactionDetails;
  final String transactionId;


  TransactionDetailsLoaded({
    required this.transactionDetails,
    required this.transactionId,
  });

  TransactionDetailsLoaded copyWith({
    Transaction? transactionDetails,
    String? transactionId,

  }) {
    return TransactionDetailsLoaded(
      transactionDetails: transactionDetails ?? this.transactionDetails,
      transactionId: transactionId ?? this.transactionId,
    );
  }
}

final class TransactionDetailsError extends TransactionDetailsState {
  final String errorMsg;

  TransactionDetailsError({required this.errorMsg});
}

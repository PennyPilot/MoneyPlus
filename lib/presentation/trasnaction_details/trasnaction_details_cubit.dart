import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:moneyplus/domain/entity/transaction.dart';
import 'package:moneyplus/domain/repository/transaction_repository.dart';
import 'package:moneyplus/presentation/trasnaction_details/pdf_service/share_pdf.dart';

import '../utils/safe_call.dart';

part 'trasnaction_details_state.dart';

class TransactionDetailsCubit extends Cubit<TransactionDetailsState> {
  final TransactionRepository transactionRepository;

  TransactionDetailsCubit({required this.transactionRepository})
    : super(TransactionDetailsLoading());

  void getTransactionDetails(String id) async {
    final result = await transactionRepository.getTransactionDetails(id);
    result.when(
      onSuccess: (details) {
        emit(
          TransactionDetailsLoaded(
            transactionDetails: details,
            transactionId: id,
          ),
        );
      },
      onError: (e) {
        emit(
          TransactionDetailsError(
            errorMsg: "Error, cannot get Translation details",
          ),
        );
      },
    );
  }

  Future<bool> deleteTransaction() async {
    try {
      await transactionRepository.deleteTransaction(
        (state as TransactionDetailsLoaded).transactionId.toString(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> onClickShareButton(BuildContext context) async {
    final transaction = (state as TransactionDetailsLoaded).transactionDetails;
    await createAndSharePdf(transaction,context);
  }
}

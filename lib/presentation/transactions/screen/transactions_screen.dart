import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:moneyplus/presentation/transactions/widget/transaction_screen_content.dart';

import '../../../core/di/injection.dart';

class TransactionsScreen extends StatelessWidget {
  final List<int>? initialCategoryIds;

  const TransactionsScreen({super.key, this.initialCategoryIds});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TransactionCubit>()..loadData(initialCategories: initialCategoryIds),
      child: const TransactionScreenContent(),
    );
  }
}

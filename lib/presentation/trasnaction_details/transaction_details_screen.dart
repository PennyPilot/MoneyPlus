import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/theme/money_colors.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/app_bar.dart';
import 'package:moneyplus/design_system/widgets/buttons/button/default_button.dart';
import 'package:moneyplus/presentation/trasnaction_details/transactionDetailsComponent.dart';
import 'package:svg_flutter/svg.dart';

import '../../design_system/widgets/buttons/error/default_error_button.dart';
import '../../domain/entity/transaction.dart';
import '../../domain/entity/transaction_category.dart';
import '../../domain/entity/transaction_type.dart';

class TransactionDetailsScreen extends StatelessWidget {
  const TransactionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: colors.surfaceLow,
        leading: _circleIcon(AppAssets.icArrowLeft,context),
        title: "Transaction details",
        trailing: _circleIcon(AppAssets.icShare,context),
      ),
      body: Container(
        height: double.infinity,
        color: colors.surface,
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: SingleChildScrollView(
            child: Center(child: TransactionDetailsComponent(transaction: fakeTransactionExpense)),
          ),
        ),
      ),
      bottomNavigationBar: _bottomBar(context),
    );
  }
}

Widget _circleIcon(String iconPath, BuildContext context){
    return GestureDetector(
      onTap: (){
        GoRouter.of(context).pop();
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: MoneyColors.light.surface,),
        alignment: Alignment.center,
        child: SvgPicture.asset(iconPath, width: 20, height: 20, matchTextDirection: true),
      ),
    );
}

Widget _bottomBar(BuildContext context){
  final localizations = context.localizations;
  return Container(
    width: double.infinity,
    color: MoneyColors.light.surface,
    child: SafeArea(
      top: false,
      right: false,
      left: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            DefaultButton(text: localizations.edit),
            DefaultErrorButton(text: localizations.delete)
          ],
        ),
      ),
    ),
  );
}

final fakeTransactionExpense = Transaction(
  id: 1,
  amount: 125.50,
  currency: "USD",
  type: TransactionType.expense,
  date: DateTime.now(),
  category: TransactionCategory(
    id: 101,
    name: "Food & Drinks",
  ),
  note: "Lunch at café",
);

final fakeTransactionIncome = Transaction(
  id: 2,
  amount: 500.00,
  currency: "USD",
  type: TransactionType.income,
  date: DateTime.now(),
  category: TransactionCategory(
    id: 201,
    name: "Salary",
  ),
  note: "Monthly paycheck",
);
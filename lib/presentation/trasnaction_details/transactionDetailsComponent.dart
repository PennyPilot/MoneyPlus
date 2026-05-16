import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/domain/entity/transaction.dart';
import 'package:moneyplus/domain/entity/transaction_type.dart';
import 'package:svg_flutter/svg.dart';

class TransactionDetailsComponent extends StatelessWidget {
  const TransactionDetailsComponent({super.key, required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final localizations = context.localizations;
    final isIncome = (transaction.type == TransactionType.income);
    final transactionColor = isIncome ? colors.green : colors.red;
    final transactionSign = isIncome ? '+' : '-';
    final locale = Localizations.localeOf(context).toString();
    final formattedDate = DateFormat.yMMMMd(locale).format(transaction.date);

    return SizedBox(
      height: 420,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              AppAssets.transactionDetailsBackground,
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                colors.surfaceLow,
                BlendMode.srcIn,
              ),
            ),
          ),
          Positioned(
            left: 55,
            right: 55,
            top: 94.24,
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                AppAssets.flowerShape3,
                width: double.infinity,
                height: 71,
                fit: BoxFit.fill,
                color: colors.surface,
              ),
            ),
          ),
          Positioned(
            right: 55,
            top: 16,
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                AppAssets.flowerShape4,
                width: 165,
                height: 71,
                fit: BoxFit.fill,
                color: colors.surface,
              ),
            ),
          ),
          Positioned(
            top: 28,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                width: 96,
                height: 112,
                AppAssets.transactionCoinStack,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            top: 140,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                isIncome
                    ? localizations.income_details
                    : localizations.expense_details,
                style: typography.title.small.copyWith(color: colors.title),
              ),
            ),
          ),
          Positioned(
            top: 172,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                "$transactionSign${transaction.amount} ${transaction.currency}",
                style: typography.headline.small.copyWith(
                  color: transactionColor,
                ),
              ),
            ),
          ),
          Positioned(
            left: 28,
            right: 28,
            top: 252,
            child: Column(
              spacing: 14,
              children: [
                _infoRow(
                  context,
                  firstValue: localizations.date,
                  secondValue: formattedDate,
                ),
                Image.asset(
                  AppAssets.lineSeparator,
                  width: double.infinity,
                  fit: BoxFit.fill,
                  height: 1,
                ),
                _infoRow(
                  context,
                  firstValue: localizations.category,
                  secondValue: transaction.category.name,
                  iconPath: AppAssets.icFrenchFries,
                ),
                Image.asset(
                  AppAssets.lineSeparator,
                  width: double.infinity,
                  fit: BoxFit.fill,
                  height: 1,
                ),
                _infoRow(
                  context,
                  firstValue: localizations.note,
                  secondValue: transaction.note,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _infoRow(
  BuildContext context, {
  required String firstValue,
  required String secondValue,
  String? iconPath,
}) {
  final colors = context.colors;
  final typography = context.typography;
  final iconPadding = (iconPath == null) ? 0.0 : 4.0;
  return Row(
    children: [
      Text(
        firstValue,
        style: typography.label.medium.copyWith(color: colors.title),
      ),
      Spacer(),
      Text(
        secondValue,
        style: typography.label.medium.copyWith(color: colors.title),
      ),
      SizedBox(width: iconPadding),
      if (iconPath != null)
        SvgPicture.asset(
          iconPath,
          colorFilter: ColorFilter.mode(colors.title, BlendMode.srcIn),
        ),
    ],
  );
}
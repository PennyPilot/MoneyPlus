import 'package:flutter/material.dart';
import 'package:moneyplus/core/l10n/app_localizations.dart';
import 'package:moneyplus/design_system/assets/app_assets.dart';
import 'package:moneyplus/design_system/constants/design_constants.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/design_system/widgets/bottom_sheet.dart';
import 'package:moneyplus/design_system/widgets/buttons/button/default_button.dart';
import 'package:moneyplus/domain/entity/transaction_type.dart';
import 'package:moneyplus/presentation/navigation/routes.dart';
import 'package:moneyplus/presentation/transactions/widget/transaction_type_card.dart';
import 'package:moneyplus/utils/extenstions/show_bottom_sheet.dart';

class AddTransactionBottomSheet extends StatefulWidget {
  final BuildContext parentContext;

  const AddTransactionBottomSheet({
    super.key,
    required this.parentContext,
  });

  @override
  State<AddTransactionBottomSheet> createState() =>
      _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState extends State<AddTransactionBottomSheet> {
  TransactionType? _selectedType;

  void _selectType(TransactionType type) {
    setState(() {
      _selectedType = type;
    });
  }

  void _onContinue() {
    final selected = _selectedType;
    if (selected == null) return;

    Navigator.of(context).pop();
    if (selected == TransactionType.income) {
      AddIncomeRoute().push(widget.parentContext);
    } else {
      AddExpenseRoute().push(widget.parentContext);
    }
  }

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;

    return MBottomSheet(
      title: l10n.add_transaction,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.add_transaction_sheet_subtitle,
            style: typography.body.small.copyWith(color: colors.body),
          ),
          const SizedBox(height: DesignConstants.spacingLarge),
          Row(
            children: [
              Expanded(
                child: TransactionTypeCard(
                  label: l10n.addIncome,
                  iconPath: AppAssets.icAddAmount,
                  selected: _selectedType == TransactionType.income,
                  onTap: () => _selectType(TransactionType.income),
                ),
              ),
              const SizedBox(width: DesignConstants.spacingSmall),
              Expanded(
                child: TransactionTypeCard(
                  label: l10n.make_expense,
                  iconPath: AppAssets.icAddExpense,
                  selected: _selectedType == TransactionType.expense,
                  onTap: () => _selectType(TransactionType.expense),
                ),
              ),
            ],
          ),
        ],
      ),
      actionButtons: [
        DefaultButton(
          text: l10n.continueButton,
          isEnabled: _selectedType != null,
          onPressed: _selectedType != null ? _onContinue : null,
        ),
      ],
    );
  }
}

void showAddTransactionBottomSheet(BuildContext context) {
  context.showBlurBottomSheet(
    AddTransactionBottomSheet(parentContext: context),
  );
}


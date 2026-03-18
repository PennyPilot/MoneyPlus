import 'package:flutter/material.dart';
import 'package:moneyplus/design_system/utils/helpers.dart';
import '../theme/money_extension_context.dart';

Future<DateTime?> showMonthYearDialog(
    BuildContext context, {
      required int initialMonth,
      required int initialYear,
    }) {
  int selectedMonth = initialMonth;
  int selectedYear = initialYear;
  final localization = context.localizations;
  final colors = context.colors;
  final typography = context.typography;

  return showDialog<DateTime>(
    context: context,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: colors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Text(
              localization.selectMonthYear,
              style: typography.title.medium.copyWith(color: colors.title),
            ),
            content: Row(
              children: [
                Expanded(
                  child: DropdownButton<int>(
                    value: selectedMonth,
                    isExpanded: true,
                    dropdownColor: colors.surface,
                    style: typography.body.medium.copyWith(color: colors.title),
                    underline: Container(height: 1, color: colors.primary),
                    items: List.generate(12, (i) => i + 1)
                        .map(
                          (m) => DropdownMenuItem(
                        value: m,
                        child: Text(getMonthNameFromNumber(m,context)),
                      ),
                    )
                        .toList(),
                    onChanged: (v) {
                      setState(() {
                        selectedMonth = v!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButton<int>(
                    value: selectedYear,
                    isExpanded: true,
                    dropdownColor: colors.surface,
                    style: typography.body.medium.copyWith(color: colors.title),
                    underline: Container(height: 1, color: colors.primary),
                    items: List.generate(50, (i) => 2000 + i)
                        .map(
                          (y) => DropdownMenuItem(
                        value: y,
                        child: Text(y.toString()),
                      ),
                    )
                        .toList(),
                    onChanged: (v) {
                      setState(() {
                        selectedYear = v!;
                      });
                    },
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  localization.cancel,
                  style: typography.label.large.copyWith(color: colors.primary),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(
                  context,
                  DateTime(selectedYear, selectedMonth),
                ),
                child: Text(
                  localization.select,
                  style: typography.label.large.copyWith(color: colors.primary),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
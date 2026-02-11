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

  return showDialog<DateTime>(
    context: context,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: context.colors.surface,
            title: Text(
              "Select month & year",
              style: context.typography.title.medium,
            ),
            content: Row(
              children: [
                Expanded(
                  child: DropdownButton<int>(
                    value: selectedMonth,
                    isExpanded: true,
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
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(
                  context,
                  DateTime(selectedYear, selectedMonth),
                ),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    },
  );
}
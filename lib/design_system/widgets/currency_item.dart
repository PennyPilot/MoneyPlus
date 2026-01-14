import 'package:flutter/material.dart';

import '../theme/money_extension_context.dart';

class CurrencyItem extends StatelessWidget {
  final String name;
  final String code;
  final String country;
  final bool isSelected;
  final VoidCallback onTap;

  const CurrencyItem({
    super.key,
    required this.name,
    required this.code,
    required this.country,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typography;

    final contentColor = isSelected ? colors.primary : colors.title;
    final subTitleColor = isSelected ? colors.primary : colors.body;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: typo.title.medium.copyWith(color: contentColor),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    country,
                    style: typo.body.medium.copyWith(color: subTitleColor),
                  ),
                ],
              ),
            ),
            Text(code, style: typo.title.medium.copyWith(color: contentColor)),
          ],
        ),
      ),
    );
  }
}

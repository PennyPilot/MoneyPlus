import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneyplus/domain/entity/categories_breakdown.dart';
import 'package:moneyplus/presentation/statistics/widgets/section_empty_view.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../design_system/theme/money_extension_context.dart';

const List<Color> _colorPaletteBase = [
  Color(0xffE04967),
  Color(0xffff7792),
  Color(0xffffa7b9),
  Color(0xffffcfd8),
];

class CategoryBreakdownWidget extends StatelessWidget {
  final CategoriesBreakdown categoriesBreakdown;

  const CategoryBreakdownWidget({super.key, required this.categoriesBreakdown});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final localizations = AppLocalizations.of(context)!;
    final numberFormat = NumberFormat.decimalPattern();

    final colorPalette = [colors.primary, ..._colorPaletteBase];
    if (categoriesBreakdown.categories.isEmpty) {
      return SectionEmptyView(
        title: localizations.categoriesBreakdown,
        message: localizations.no_monthly_breakdown,
      );
    }
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Text(
            localizations.categoriesBreakdown,
            style: typography.label.medium.copyWith(color: colors.title),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: categoriesBreakdown.categories.asMap().entries.map(( 
                entry,
              ) {
                final index = entry.key;
                final category = entry.value;
                return Expanded(
                  flex: (category.percentage * 1000).toInt(),
                  child: Container(
                    height: 24,
                    margin: EdgeInsets.only(
                      right: index == categoriesBreakdown.categories.length - 1
                          ? 0
                          : 2,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: colorPalette[index % colorPalette.length],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Row(
            spacing: 4,
            children: [
              Text(
                numberFormat.format(categoriesBreakdown.totalSpend),
                style: typography.label.medium.copyWith(color: colors.title),
              ),
              Text(
                localizations.totalSpend,
                style: typography.label.xSmall!.copyWith(color: colors.body),
              ),
            ],
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categoriesBreakdown.categories.length,
            itemBuilder: (context, index) {
              final category = categoriesBreakdown.categories[index];
              final color = colorPalette[index % colorPalette.length];
              return _buildCategoryItem(context, category, color, numberFormat, localizations);
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(color: colors.stroke, thickness: .5);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    BreakDownCategory category,
    Color color,
    NumberFormat numberFormat,
    AppLocalizations localizations,
  ) {
    final colors = context.colors;
    final typography = context.typography;
    return Row(
      spacing: 4,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Text(
          "${(category.percentage).toStringAsFixed(0)}%",
          textAlign: TextAlign.end,
          style: typography.label.xSmall!.copyWith(color: colors.title),
        ),
        Expanded(
          child: Text(
            category.name,
            style: typography.label.xSmall!.copyWith(color: colors.body),
          ),
        ),
        Text(localizations.moneyAmount(
          numberFormat.format(category.spend),
          localizations.currencyCode,
        )
        ,style: typography.label.small.copyWith(color: colors.title),
        ),
      ],
    );
  }
}
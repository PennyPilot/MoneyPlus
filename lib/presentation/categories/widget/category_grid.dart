import 'package:flutter/material.dart';
import 'package:moneyplus/domain/entity/category.dart';
import 'package:moneyplus/presentation/categories/widget/category_chip.dart';

class CategoryGrid extends StatelessWidget {
  final List<Category> categories;
  final bool isArabic;
  final Function(Category) onEditCategory;

  const CategoryGrid({
    super.key,
    required this.categories,
    required this.isArabic,
    required this.onEditCategory,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.only(top: 16, start: 16, end: 16),
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.start,
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            final name = (isArabic && category.nameAr.trim().isNotEmpty)
                ? category.nameAr
                : category.name;

            return CategoryChip(
              label: name,
              onEdit: () => onEditCategory(category),
            );
          }).toList(),
        ),
      ),
    );
  }
}

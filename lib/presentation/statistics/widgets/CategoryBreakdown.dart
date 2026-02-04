import 'package:flutter/material.dart';
import 'package:moneyplus/domain/entity/categories_breakdown.dart';

class CategoryBreakdownWidget extends StatelessWidget {
  final CategoriesBreakdown categoriesBreakdown;

  const CategoryBreakdownWidget({super.key, required this.categoriesBreakdown});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Categories Breakdown"),
        LinearProgressIndicator(value: .5),
        Text("Total Spend: ${categoriesBreakdown.totalSpend}"),
        ListView.separated(
          shrinkWrap: true,
          itemCount: categoriesBreakdown.categories.length,
          itemBuilder: (context, index) {
            final category = categoriesBreakdown.categories[index];
            return _buildCategoryItem(category);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(color: Colors.grey, thickness: 1);
          },
        ),
      ],
    );
  }

  Widget _buildCategoryItem(BreakDownCategory category) {
    return ListTile(
      title: Text(category.name),
      subtitle: Text("Percentage: ${category.percentage}%"),
    );
  }
}

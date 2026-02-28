
class CategoriesBreakdown {
    final List<BreakDownCategory> categories;
    final double totalSpend;

    CategoriesBreakdown({
        required this.categories,
        required this.totalSpend,
    });

    factory CategoriesBreakdown.fromJson(Map<String, dynamic> json) => CategoriesBreakdown(
        categories: List<BreakDownCategory>.from(json["categories"].map((category) => BreakDownCategory.fromJson(category))),
        totalSpend: json["total_spend"]?.toDouble(),
    );
}

class BreakDownCategory {
    final int? id;
    final String name;
    final double spend;
    final double percentage;

    BreakDownCategory({
        this.id,
        required this.name,
        required this.spend,
        required this.percentage,
    });

    factory BreakDownCategory.fromJson(Map<String, dynamic> json) => BreakDownCategory(
        id: json["id"],
        name: json["name"],
        spend: json["spend"]?.toDouble(),
        percentage: json["percentage"]?.toDouble(),
    );
}

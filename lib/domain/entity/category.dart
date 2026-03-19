class Category {
  final int id;
  final String name;
  final String userId;
  final String nameAr;
  final bool isIncome;

  const Category({
    this.id = 0,
    required this.name,
    this.nameAr = '',
    this.userId = '',
    this.isIncome = false,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      nameAr: json['name_ar'] ?? '',
      userId: json['user_id'] ?? '',
      isIncome: json['is_income'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'name_ar': nameAr,
      'is_income': isIncome,
    };
    if (id != 0) map['id'] = id;
    if (userId.isNotEmpty) map['user_id'] = userId;
    return map;
  }

  Category copyWith({
    int? id,
    String? name,
    String? nameAr,
    String? userId,
    bool? isIncome,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      userId: userId ?? this.userId,
      isIncome: isIncome ?? this.isIncome,
    );
  }
}

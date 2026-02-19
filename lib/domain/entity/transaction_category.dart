class TransactionCategory {
  final int id;
  final String name;

  TransactionCategory({required this.id, required this.name});

  TransactionCategory copyWith({int? id, String? name}) {
    return TransactionCategory(id: id ?? this.id, name: name ?? this.name);
  }

  factory TransactionCategory.fromJson(Map<String, dynamic> json) {
    return TransactionCategory(
      id: json['id'],
      name: json['name'],
    );
  }
}

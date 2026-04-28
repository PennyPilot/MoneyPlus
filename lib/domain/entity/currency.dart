
class Currency {
  final int id;
  final String name;
  final String country;
  final String abbreviation ;

  Currency({
    required this.id,
    required this.name,
    required this.country,
    required this.abbreviation,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      country: json['country'] as String? ?? '',
      abbreviation: json['abbreviation'] as String? ?? '',
    );
  }

}
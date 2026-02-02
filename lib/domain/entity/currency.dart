
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
      id: json['id'],
      name: json['name'],
      country: json['country'],
      abbreviation: json['abbreviation'],
    );
  }

}
class CurrencyRate {
  final dynamic id;
  final String name;
  final String abbreviation;
  final double ratio;

  CurrencyRate({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.ratio,
  });

  factory CurrencyRate.fromJson(Map<String, dynamic> json) {
    return CurrencyRate(
      id: json['id'],
      name: json['name'] as String? ?? '',
      abbreviation: json['abbreviation'] as String? ?? '',
      ratio: (json['ratio'] as num? ?? 1.0).toDouble(),
    );
  }
}

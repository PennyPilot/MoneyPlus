class CurrencyRate {
  final int id;
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
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      abbreviation: json['abbreviation'] as String? ?? '',
      ratio: (json['ratio'] as num? ?? 1.0).toDouble(),
    );
  }
}

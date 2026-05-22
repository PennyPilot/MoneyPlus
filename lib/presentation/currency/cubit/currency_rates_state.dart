import 'package:equatable/equatable.dart';
import 'package:moneyplus/domain/entity/currency.dart';
import 'package:moneyplus/domain/repository/model/currency_rate.dart';

class CurrencyRatesState extends Equatable {
  final List<Currency> allCurrencies;
  final Currency? baseCurrency;
  final List<CurrencyRate> rates;
  final CurrencyRate? selectedTarget;
  final String amount;
  final double result;
  final DateTime date;
  final bool isLoading;
  final String? errorMessage;

  const CurrencyRatesState({
    this.allCurrencies = const [],
    this.baseCurrency,
    this.rates = const [],
    this.selectedTarget,
    this.amount = '1',
    this.result = 0.0,
    required this.date,
    this.isLoading = false,
    this.errorMessage,
  });

  factory CurrencyRatesState.initial() {
    return CurrencyRatesState(date: DateTime.now());
  }

  CurrencyRatesState copyWith({
    List<Currency>? allCurrencies,
    Currency? baseCurrency,
    List<CurrencyRate>? rates,
    CurrencyRate? selectedTarget,
    String? amount,
    double? result,
    DateTime? date,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CurrencyRatesState(
      allCurrencies: allCurrencies ?? this.allCurrencies,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      rates: rates ?? this.rates,
      selectedTarget: selectedTarget ?? this.selectedTarget,
      amount: amount ?? this.amount,
      result: result ?? this.result,
      date: date ?? this.date,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        allCurrencies,
        baseCurrency,
        rates,
        selectedTarget,
        amount,
        result,
        date,
        isLoading,
        errorMessage,
      ];
}

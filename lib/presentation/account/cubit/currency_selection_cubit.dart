import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entity/currency.dart';
import '../../../domain/repository/account_repository.dart';

class CurrencySelectionState extends Equatable {
  final List<Currency> currencies;
  final List<Currency> filteredCurrencies;
  final bool isLoading;
  final String query;
  final String? errorMessage;

  const CurrencySelectionState({
    this.currencies = const [],
    this.filteredCurrencies = const [],
    this.isLoading = false,
    this.query = '',
    this.errorMessage,
  });

  CurrencySelectionState copyWith({
    List<Currency>? currencies,
    List<Currency>? filteredCurrencies,
    bool? isLoading,
    String? query,
    String? errorMessage,
  }) {
    return CurrencySelectionState(
      currencies: currencies ?? this.currencies,
      filteredCurrencies: filteredCurrencies ?? this.filteredCurrencies,
      isLoading: isLoading ?? this.isLoading,
      query: query ?? this.query,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [currencies, filteredCurrencies, isLoading, query, errorMessage];
}

class CurrencySelectionCubit extends Cubit<CurrencySelectionState> {
  final AccountRepository _accountRepository;

  CurrencySelectionCubit(this._accountRepository) : super(const CurrencySelectionState());

  Future<void> fetchCurrencies() async {
    emit(state.copyWith(isLoading: true));
    try {
      final currencies = await _accountRepository.getCurrencies();
      emit(state.copyWith(
        currencies: currencies,
        filteredCurrencies: currencies,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void onSearchChanged(String query) {
    final filtered = state.currencies
        .where((currency) =>
            currency.name.toLowerCase().contains(query.toLowerCase()) ||
            currency.abbreviation.toLowerCase().contains(query.toLowerCase()))
        .toList();

    emit(state.copyWith(
      query: query,
      filteredCurrencies: filtered,
    ));
  }
}

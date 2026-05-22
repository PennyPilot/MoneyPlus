import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/domain/entity/currency.dart';
import 'package:moneyplus/domain/repository/account_repository.dart';
import 'package:moneyplus/domain/repository/transaction_repository.dart';
import 'package:moneyplus/domain/repository/user_money_repository.dart';
import 'currency_rates_state.dart';

class CurrencyRatesCubit extends Cubit<CurrencyRatesState> {
  final TransactionRepository transactionRepository;
  final UserMoneyRepository userMoneyRepository;
  final AccountRepository accountRepository;

  CurrencyRatesCubit({
    required this.transactionRepository,
    required this.userMoneyRepository,
    required this.accountRepository,
  }) : super(CurrencyRatesState.initial());

  Future<void> init() async {
    emit(state.copyWith(isLoading: true));
    try {
      final currencies = await accountRepository.getCurrencies();
      final defaultCurrency = await userMoneyRepository.getCurrency();
      
      emit(state.copyWith(
        allCurrencies: currencies,
        baseCurrency: defaultCurrency,
      ));

      await loadRates();
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> loadRates({DateTime? date}) async {
    if (state.baseCurrency == null) return;
    
    emit(state.copyWith(isLoading: true));
    try {
      final targetDate = date ?? state.date;
      
      final rawRates = await transactionRepository.getExchangeRate(
        baseCurrencyId: state.baseCurrency!.id,
        date: targetDate,
      );

      final enrichedRates = rawRates;
      
      final updatedBaseCurrency = enrichedRates.where((r) => r.id == state.baseCurrency?.id).firstOrNull;
      
      var newTarget = enrichedRates.where((r) => r.id == state.selectedTarget?.id).firstOrNull;
      newTarget ??= enrichedRates.where((r) => r.id != state.baseCurrency!.id).firstOrNull;
      newTarget ??= enrichedRates.firstOrNull;

      emit(state.copyWith(
        rates: enrichedRates,
        baseCurrency: updatedBaseCurrency != null 
            ? Currency(
                id: updatedBaseCurrency.id, 
                name: updatedBaseCurrency.name, 
                country: state.baseCurrency?.country ?? '', 
                abbreviation: updatedBaseCurrency.abbreviation
              ) 
            : state.baseCurrency,
        date: targetDate,
        selectedTarget: newTarget,
        isLoading: false,
      ));
      
      _calculateResult();
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void onBaseCurrencyChanged(dynamic currencyId) async {
    final rate = state.rates.where((r) => r.id == currencyId).firstOrNull;
    final Currency? newBase;
    
    if (rate != null) {
      newBase = Currency(
        id: rate.id, 
        name: rate.name, 
        country: '', 
        abbreviation: rate.abbreviation
      );
    } else {
      newBase = state.allCurrencies.where((c) => c.id == currencyId).firstOrNull;
    }

    if (newBase != null) {
      emit(state.copyWith(baseCurrency: newBase));
      await loadRates();
    }
  }

  void onTargetCurrencyChanged(dynamic targetId) {
    final newTarget = state.rates.where((r) => r.id == targetId).firstOrNull;
    if (newTarget != null) {
      emit(state.copyWith(selectedTarget: newTarget));
      _calculateResult();
    }
  }

  void onAmountChanged(String value) {
    emit(state.copyWith(amount: value));
    _calculateResult();
  }

  void onDateChanged(DateTime date) async {
    await loadRates(date: date);
  }

  void _calculateResult() {
    if (state.selectedTarget == null) return;
    
    final parsedAmount = double.tryParse(state.amount) ?? 0.0;
    final rawResult = parsedAmount * state.selectedTarget!.ratio;
    
    emit(state.copyWith(result: rawResult));
  }
}

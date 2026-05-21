import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/domain/repository/model/currency_breakdown.dart';
import 'package:moneyplus/domain/repository/user_money_repository.dart';
import 'package:moneyplus/presentation/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final UserMoneyRepository userMoneyRepository;

  HomeCubit({required this.userMoneyRepository}) : super(HomeLoading());

  void getData({required int month, required int year}) async {
    emit(HomeLoading());
    try {
      final results = await Future.wait([
        getTotalBalance(),
        getTotalMonthIncome(month, year),
        getTotalMonthExpense(month, year),
        getCurrencyBreakdown(month, year),
        getCurrency(),
      ]);

      final balance = results[0] as double;
      final income = results[1] as double;
      final expense = results[2] as double;
      final breakdown = results[3] as List<CurrencyBreakdown>;
      final curr = results[4] as String;

      final percentage = await userMoneyRepository.getSavingSpendingPercentage(
        month,
        year,
        currentIncome: income,
        currentExpense: expense,
      );

      final loadedContent = HomeLoaded(
        currentBalance: balance,
        currentSavingSpendingPercentage: percentage,
        totalMonthIncome: income,
        totalMonthExpense: expense,
        currencyBreakdown: breakdown,
        currency: curr,
        selectedMonth: month,
        selectedYear: year,
      );
      emit(loadedContent);
    } catch (e) {
      print("error in home cubit: $e");
      emit(HomeError(errorMessage: "Failed to get Data"));
    }
  }

  void setSelectedDate(int month, int year) async {
    if (state is! HomeLoaded) return;
    final loadedState = state as HomeLoaded;

    if (loadedState.selectedMonth == month && loadedState.selectedYear == year) {
      return;
    }
    emit(HomeLoading());
    final expense = await getTotalMonthExpense(month, year);
    final income = await getTotalMonthIncome(month, year);
    final currencyBreakdown = await getCurrencyBreakdown(month, year);
    final savingSpendingPercentage = await getSavingSpendingPercentage(month, year);
    emit(
      loadedState.copyWith(
        totalMonthIncome: income,
        totalMonthExpense: expense,
        currencyBreakdown: currencyBreakdown,
        currentSavingSpendingPercentage: savingSpendingPercentage,
        selectedMonth: month,
        selectedYear: year,
      ),
    );
  }

  void onRefreshHomeScreen(){
    final currentDate = DateTime.now();
    getData(month: currentDate.month, year: currentDate.year);
  }

  Future<double> getTotalBalance() async {
    return await userMoneyRepository.getTotalBalance();
  }

  Future<double> getSavingSpendingPercentage(int month, int year) async {
    return await userMoneyRepository.getSavingSpendingPercentage(month, year);
  }

  Future<double> getTotalMonthIncome(int month, int year) async {
    return await userMoneyRepository.getMonthIncome(month, year);
  }

  Future<double> getTotalMonthExpense(int month, int year) async {
    return await userMoneyRepository.getMonthExpense(month, year);
  }

  Future<List<CurrencyBreakdown>> getCurrencyBreakdown(
    int month,
    int year,
  ) async {
    return await userMoneyRepository.getCurrencyBreakdown(
      month: month,
      year: year,
    );
  }

  Future<String> getCurrency() async {
    return await userMoneyRepository.getCurrency().then(
      (value) => value.abbreviation,
    );
  }
}

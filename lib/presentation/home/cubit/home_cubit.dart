import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/domain/repository/model/balance_status.dart';
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
        userMoneyRepository.getBalanceStatus(month: month, year: year),
        userMoneyRepository.getCurrencyBreakdown(month: month, year: year),
      ]);

      final balanceStatus = results[0] as BalanceStatus;
      final breakdown = results[1] as List<CurrencyBreakdown>;

      final loadedContent = HomeLoaded(
        currentBalance: balanceStatus.currentBalance,
        currentSavingSpendingPercentage: balanceStatus.savingSpendingPercentage,
        totalMonthIncome: balanceStatus.monthIncome,
        totalMonthExpense: balanceStatus.monthExpense,
        currencyBreakdown: breakdown,
        currency: balanceStatus.defaultCurrency.abbreviation,
        selectedMonth: month,
        selectedYear: year,
      );
      emit(loadedContent);
    } catch (e) {
      emit(HomeError(errorMessage: "Failed to get Data"));
    }
  }

  void setSelectedDate(int month, int year) async {
    if (state is! HomeLoaded) return;
    final loadedState = state as HomeLoaded;

    if (loadedState.selectedMonth == month && loadedState.selectedYear == year) {
      return;
    }
    getData(month: month, year: year);
  }

  void onRefreshHomeScreen(){
    final currentDate = DateTime.now();
    getData(month: currentDate.month, year: currentDate.year);
  }
}

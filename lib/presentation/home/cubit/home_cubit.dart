import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/domain/repository/model/top_spending_category.dart';
import 'package:moneyplus/domain/repository/user_money_repository.dart';
import 'package:moneyplus/presentation/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final UserMoneyRepository userMoneyRepository;

  final _topSpendingCount = 5;

  HomeCubit({required this.userMoneyRepository}) : super(HomeLoading());

  void getData({required int month, required int year}) async {
    emit(HomeLoading());
    try {
      final loadedContent = HomeLoaded(
        currentBalance: await getTotalBalance(),
        currentSavingSpendingPercentage: await getSavingSpendingPercentage(
          month,
          year,
        ),
        totalMonthIncome: await getTotalMonthIncome(month, year),
        totalMonthExpense: await getTotalMonthExpense(month, year),
        topSpendingCategories: await getTopSpendingCategories(month, year),
        currency: await getCurrency(),
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
    final topSpendingCategories = await getTopSpendingCategories(month, year);
    final savingSpendingPercentage = await getSavingSpendingPercentage(month, year);
    emit(
      loadedState.copyWith(
        totalMonthIncome: income,
        totalMonthExpense: expense,
        topSpendingCategories: topSpendingCategories,
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

  Future<List<TopSpendingCategory>> getTopSpendingCategories(
    int month,
    int year,
  ) async {
    return await userMoneyRepository.getTopSpendingCategoriesInMonth(
      month: month,
      year: year,
      count: _topSpendingCount,
    );
  }

  Future<String> getCurrency() async {
    return await userMoneyRepository.getCurrency().then(
      (value) => value.abbreviation,
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/domain/repository/model/top_spending_category.dart';
import 'package:moneyplus/domain/repository/user_money_repository.dart';
import 'package:moneyplus/presentation/home/cubit/home_state.dart';
import '../../../domain/repository/model/month_enum.dart';

class HomeCubit extends Cubit<HomeState> {
  final UserMoneyRepository userMoneyRepository;

  HomeCubit({required this.userMoneyRepository}) : super(HomeLoading());

  void getData({required Month month, required int year}) async {
    try {
      final loadedContent = HomeLoaded(
        currentBalance: await getTotalBalance(),
        currentSavingSpendingPercentage: await getSavingSpendingPercentage(month, year),
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

  void setSelectedDate(Month month, int year) async {
    if ((state as HomeLoaded).selectedMonth == month &&
        (state as HomeLoaded).selectedYear == year) {
      return;
    }
    final loadedState = state as HomeLoaded;
    emit(HomeLoading());
    var expense = await getTotalMonthExpense(month, year);
    var income = await getTotalMonthIncome(month, year);
    emit(
      loadedState.copyWith(
        totalMonthIncome: income,
        totalMonthExpense: expense,
        selectedMonth: month,
        selectedYear: year,
      ),
    );
  }

  Future<double> getTotalBalance() async {
    return await userMoneyRepository.getTotalBalance();
  }

  Future<double> getSavingSpendingPercentage(Month month, int year) async {
    return await userMoneyRepository.getSavingSpendingPercentage(month, year);
  }

  Future<double> getTotalMonthIncome(Month month, int year) async {
    return await userMoneyRepository.getMonthIncome(month, year);
  }

  Future<double> getTotalMonthExpense(Month month, int year) async {
    return await userMoneyRepository.getMonthExpense(month, year);
  }

  Future<List<TopSpendingCategory>> getTopSpendingCategories(
    Month month,
    int year,
  ) async {
    return await userMoneyRepository.getTopSpendingCategoriesInMonth(month: month, year: year, count: 5);
  }

  Future<String> getCurrency() async {
    return await userMoneyRepository.getCurrency();
  }
}

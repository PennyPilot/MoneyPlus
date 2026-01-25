import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/presentation/home/cubit/home_state.dart';
import '../models/CategoryExpense.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeLoading(isLoading: true));

  void getData({required Month month, required int year}) async {
    try{
      final loadedContent = HomeLoaded(
        currentBalance: await getTotalBalance(),
        currentSavingSpendingPercentage: await getSavingSpendingPercentage(),
        totalMonthIncome: await getTotalMonthIncome(month, year),
        totalMonthExpense: await getTotalMonthExpense(month, year),
        topSpendingCategories: await getTopSpendingCategories(),
        currency: await getCurrency(),
        selectedMonth: month,
        selectedYear: year,
      );
      emit(loadedContent);
    }catch(e){
      emit(HomeError(errorMessage: "Failed to get Data"));
    }

  }

  void setSelectedDate(Month month, int year){
    print('setSelectedDate in cubit is: $month');
    if(state is HomeLoaded){
      final s = state as HomeLoaded;
      emit(s.copyWith(selectedMonth: month, selectedYear: year));
    }
  }

  Future<double> getTotalBalance() async {
    // TODO: Fetch from repository
    return 500_000;
  }

  Future<double> getSavingSpendingPercentage() async {
    // TODO: Fetch from repository
    return 30;
  }

  Future<double> getTotalMonthIncome(Month month, int year) async {
    // TODO: Fetch from repository
    return 80_000;
  }

  Future<double> getTotalMonthExpense(Month month, int year) async {
    // TODO: Fetch from repository
    return 50_000;
  }

  Future<List<CategoryExpense>> getTopSpendingCategories() async {
    // TODO: Fetch from repository
    return getFakeTopSpendingCategories();
  }

  Future<String> getCurrency() async {
    // TODO: Fetch from repository
    return 'EGY';
  }
}

List<CategoryExpense> getFakeTopSpendingCategories() {
  return [
    CategoryExpense(
      categoryName: "Food",
      amount: 10000,
      transactionCount: 15,
      percentage: 33.3,
    ),
    CategoryExpense(
      categoryName: "Transport",
      amount: 5000,
      transactionCount: 8,
      percentage: 16.7,
    ),
    CategoryExpense(
      categoryName: "Entertainment",
      amount: 8000,
      transactionCount: 12,
      percentage: 26.7,
    ),
    CategoryExpense(
      categoryName: "Shopping",
      amount: 7000,
      transactionCount: 10,
      percentage: 23.3,
    ),
  ];
}

enum Month {
  january('January'),
  february('February'),
  march('March'),
  april('April'),
  may('May'),
  june('June'),
  july('July'),
  august('August'),
  september('September'),
  october('October'),
  november('November'),
  december('December');

  final String label;

  const Month(this.label);
}

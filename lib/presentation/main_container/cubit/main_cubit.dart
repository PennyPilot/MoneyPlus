import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/design_system/widgets/nav_bar.dart';
import 'package:moneyplus/presentation/main_container/cubit/main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(const MainState());

  void onTabSelected(NavBarTab selectedTab) {
    if (state.selectedTab == selectedTab) return;
    emit(state.copyWith(selectedTab: selectedTab, clearFilters: true));
  }

  void navigateToTransactionsWithFilter(List<int> categoryIds) {
    emit(state.copyWith(
      selectedTab: NavBarTab.transaction,
      transactionCategoryFilters: categoryIds,
    ));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:moneyplus/design_system/widgets/nav_bar.dart';

@immutable
class MainState {
  final NavBarTab selectedTab;
  final List<int>? transactionCategoryFilters;

  const MainState({
    this.selectedTab = NavBarTab.home,
    this.transactionCategoryFilters,
  });

  MainState copyWith({
    NavBarTab? selectedTab,
    List<int>? transactionCategoryFilters,
    bool clearFilters = false,
  }) {
    return MainState(
      selectedTab: selectedTab ?? this.selectedTab,
      transactionCategoryFilters:
          clearFilters ? null : (transactionCategoryFilters ?? this.transactionCategoryFilters),
    );
  }
}

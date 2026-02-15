import 'package:flutter/cupertino.dart';
import 'package:moneyplus/design_system/widgets/nav_bar.dart';

@immutable
class MainState {
  final NavBarTab selectedTab;

  const MainState({this.selectedTab = NavBarTab.home});

  MainState copyWith(NavBarTab? selectedTab) {
    return MainState(selectedTab: selectedTab ?? this.selectedTab);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:moneyplus/presentation/accout/screen/account_screen.dart';
import 'package:moneyplus/presentation/main_container/cubit/main_state.dart';
import 'package:moneyplus/presentation/statistics/statistics_screen.dart';
import 'package:moneyplus/presentation/transactions/screen/transactions_screen.dart';

import '../../../design_system/widgets/nav_bar.dart';
import '../../home/screen/home_screen.dart';
import '../../statistics/statistics_screen.dart';
import '../cubit/main_cubit.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit(),
      child: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: context.colors.surface,
            body: _getScreenForTab(state.selectedTab),
            bottomNavigationBar: NavBar(
              selectedTab: state.selectedTab,
              onTabSelected: (tab) {
                context.read<MainCubit>().onTabSelected(tab);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _getScreenForTab(NavBarTab tab) {
    switch (tab) {
      case NavBarTab.home:
        return const HomeScreen();
      case NavBarTab.transaction:
        return const TransactionsScreen();
      case NavBarTab.statistics:
        return const StatisticsScreen();
      case NavBarTab.account:
        return const AccountScreen();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moneyplus/presentation/expense/screen/expense_screen.dart';
import 'package:moneyplus/presentation/home/screen/home_screen.dart';
import 'package:moneyplus/presentation/login/screen/login_screen.dart';

import '../../di/injection.dart';
import '../income/screen/income_screen.dart';
import '../login/cubit/login_cubit.dart';
import '../trasnaction_details/transaction_details_screen.dart';
import '../main_container/screen/main_screen.dart';

part 'routes.g.dart';

@TypedGoRoute<OnBoardingRoute>(path: '/')
@immutable
class OnBoardingRoute extends GoRouteData with $OnBoardingRoute {
  const OnBoardingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("onBoarding screen"),
            ElevatedButton(onPressed: (){ LoginRoute().push(context);}, child: Text("Go to Login"))
          ],
        ),
      ),
    );
  }
}

@TypedGoRoute<LoginRoute>(path: '/login')
@immutable
class LoginRoute extends GoRouteData with $LoginRoute {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: const LoginScreen(),
    );
  }
}

@TypedGoRoute<MainRoute>(path: '/main')
@immutable
class MainRoute extends GoRouteData with $MainRoute {
  const MainRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MainScreen();
  }
}

@TypedGoRoute<TransactionDetailsRoute>(path: '/transaction_details')
@immutable
class TransactionDetailsRoute extends GoRouteData with $TransactionDetailsRoute {
  final String transactionId;
  TransactionDetailsRoute(this.transactionId);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return TransactionDetailsScreen(transactionId: transactionId);
  }
}

@TypedGoRoute<AddIncomeRoute>(path: '/add-income')
@immutable
class AddIncomeRoute extends GoRouteData with $AddIncomeRoute {
  const AddIncomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const IncomeScreen();
  }
}

@TypedGoRoute<AddExpenseRoute>(path: '/add-expense')
@immutable
class AddExpenseRoute extends GoRouteData with $AddExpenseRoute {
  const AddExpenseRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ExpenseScreen();
  }
}

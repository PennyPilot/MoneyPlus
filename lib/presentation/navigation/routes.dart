import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moneyplus/presentation/createAccount/screen/create_account_screen.dart';
import 'package:moneyplus/presentation/expense/screen/add_expense_screen.dart';
import 'package:moneyplus/presentation/login/screen/login_screen.dart';
import 'package:moneyplus/presentation/update_password/screen/update_password_screen.dart';

import '../../core/di/injection.dart';
import '../forget_password/screen/forget_password_screen.dart';
import '../income/screen/add_income_screen.dart';
import '../login/cubit/login_cubit.dart';
import '../main_container/screen/main_screen.dart';
import '../statistics/cubit/statistics_cubit.dart';
import '../statistics/statistics_screen.dart';
import '../trasnaction_details/transaction_details_screen.dart';

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

@TypedGoRoute<CreateAccountRoute>(path: '/createAccount')
@immutable
class CreateAccountRoute extends GoRouteData
    with $CreateAccountRoute {
  const CreateAccountRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CreateAccountScreen();
  }
}

@TypedGoRoute<StatisticsRoute>(path: '/statistics')
@immutable
class StatisticsRoute extends GoRouteData
    with $StatisticsRoute {
  const StatisticsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (_) => getIt<StatisticsCubit>(),
      child: const StatisticsScreen(),
    );
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

@TypedGoRoute<ForgetPasswordRoute>(path: '/forget_password')
@immutable
class ForgetPasswordRoute extends GoRouteData with $ForgetPasswordRoute {
  const ForgetPasswordRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ForgetPasswordScreen();
  }
}

@TypedGoRoute<UpdatePasswordRoute>(path: '/update_password')
@immutable
class UpdatePasswordRoute extends GoRouteData with $UpdatePasswordRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return UpdatePasswordScreen();
  }
}

@TypedGoRoute<AddIncomeRoute>(path: '/add-income')
@immutable
class AddIncomeRoute extends GoRouteData with $AddIncomeRoute {
  const AddIncomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AddIncomeScreen();
  }
}

@TypedGoRoute<AddExpenseRoute>(path: '/add-expense')
@immutable
class AddExpenseRoute extends GoRouteData with $AddExpenseRoute {
  const AddExpenseRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AddExpenseScreen();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moneyplus/presentation/createAccount/screen/create_account_screen.dart';
import 'package:moneyplus/presentation/edit_salary/salary_settings_screen.dart';
import 'package:moneyplus/presentation/expense/screen/add_expense_screen.dart';
import 'package:moneyplus/presentation/login/screen/login_screen.dart';
import 'package:moneyplus/presentation/update_password/screen/update_password_screen.dart';

import '../../core/di/injection.dart';
import '../categories/screen/manage_categories_screen.dart';
import '../forget_password/screen/forget_password_screen.dart';
import '../income/screen/add_income_screen.dart';
import '../login/cubit/login_cubit.dart';
import '../main_container/screen/main_screen.dart';
import '../profileSetting/screen/profile_settings_screen.dart';
import '../statistics/cubit/statistics_cubit.dart';
import '../statistics/statistics_screen.dart';
import '../trasnaction_details/transaction_details_screen.dart';

part 'routes.g.dart';


abstract class RoutePaths {
  static const String initial = '/';
  static const String onBoarding = '/onboarding';
  static const String login = '/login';
  static const String main = '/main';
  static const String createAccount = '/createAccount';
  static const String statistics = '/statistics';
  static const String transactionDetails = '/transaction_details';
  static const String forgetPassword = '/forget_password';
  static const String updatePassword = '/update_password';
  static const String addIncome = '/add-income';
  static const String addExpense = '/add-expense';
  static const String profileSettings = '/profile-settings';
}

@TypedGoRoute<InitialRoute>(
  path: RoutePaths.initial,
  routes: [
    TypedGoRoute<LoginRoute>(path: 'login'),
    TypedGoRoute<OnBoardingRoute>(path: 'onboarding'),
    TypedGoRoute<MainRoute>(path: 'main'),
    TypedGoRoute<CreateAccountRoute>(path: 'createAccount'),
    TypedGoRoute<ForgetPasswordRoute>(path: 'forget_password'),
    TypedGoRoute<UpdatePasswordRoute>(path: 'update_password'),
    TypedGoRoute<AddIncomeRoute>(path: 'add-income'),
    TypedGoRoute<AddExpenseRoute>(path: 'add-expense'),
    TypedGoRoute<StatisticsRoute>(path: 'statistics'),
    TypedGoRoute<TransactionDetailsRoute>(path: 'transaction_details'),
    TypedGoRoute<ManageCategoriesRoute>(path: 'manage-categories'),
    TypedGoRoute<EditSalaryRoute>(path: 'edit-salary'),
  ],
)
@immutable
class InitialRoute extends GoRouteData with $InitialRoute {
  const InitialRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

@TypedGoRoute<OnBoardingRoute>(path: RoutePaths.onBoarding)
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
            const Text("onBoarding screen"),
            ElevatedButton(
              onPressed: () {
                const LoginRoute().push(context);
              },
              child: const Text("Go to Login"),
            ),
          ],
        ),
      ),
    );
  }
}

@TypedGoRoute<LoginRoute>(path: RoutePaths.login)
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

@TypedGoRoute<MainRoute>(path: RoutePaths.main)
@immutable
class MainRoute extends GoRouteData with $MainRoute {
  const MainRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MainScreen();
  }
}

@TypedGoRoute<CreateAccountRoute>(path: RoutePaths.createAccount)
@immutable
class CreateAccountRoute extends GoRouteData with $CreateAccountRoute {
  const CreateAccountRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CreateAccountScreen();
  }
}

@TypedGoRoute<ProfileSettingsRoute>(path: RoutePaths.profileSettings)
@immutable
class ProfileSettingsRoute extends GoRouteData with $ProfileSettingsRoute {
  final String name;
  final String email;
  const ProfileSettingsRoute({required this.name, required this.email});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProfileSettingsScreen(
      name: name,
      email: email,
    );
  }
}

@TypedGoRoute<StatisticsRoute>(path: RoutePaths.statistics)
@immutable
class StatisticsRoute extends GoRouteData with $StatisticsRoute {
  const StatisticsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (_) => getIt<StatisticsCubit>(),
      child: const StatisticsScreen(),
    );
  }
}

@TypedGoRoute<TransactionDetailsRoute>(path: RoutePaths.transactionDetails)
@immutable
class TransactionDetailsRoute extends GoRouteData
    with $TransactionDetailsRoute {
  final String transactionId;
  TransactionDetailsRoute(this.transactionId);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return TransactionDetailsScreen(transactionId: transactionId);
  }
}

@TypedGoRoute<ForgetPasswordRoute>(path: RoutePaths.forgetPassword)
@immutable
class ForgetPasswordRoute extends GoRouteData with $ForgetPasswordRoute {
  const ForgetPasswordRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ForgetPasswordScreen();
  }
}

@TypedGoRoute<UpdatePasswordRoute>(path: RoutePaths.updatePassword)
@immutable
class UpdatePasswordRoute extends GoRouteData with $UpdatePasswordRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return UpdatePasswordScreen();
  }
}

@TypedGoRoute<AddIncomeRoute>(path: RoutePaths.addIncome)
@immutable
class AddIncomeRoute extends GoRouteData with $AddIncomeRoute {
  const AddIncomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AddIncomeScreen();
  }
}

@TypedGoRoute<AddExpenseRoute>(path: RoutePaths.addExpense)
@immutable
class AddExpenseRoute extends GoRouteData with $AddExpenseRoute {
  const AddExpenseRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AddExpenseScreen();
  }
}

@TypedGoRoute<ManageCategoriesRoute>(path: '/manage-categories')
@immutable
class ManageCategoriesRoute extends GoRouteData with $ManageCategoriesRoute {
  const ManageCategoriesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ManageCategoriesScreen();
  }
}

@TypedGoRoute<EditSalaryRoute>(path: '/edit-salary')
@immutable
class EditSalaryRoute extends GoRouteData with $EditSalaryRoute {
  const EditSalaryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SalarySettingsScreen();
  }
}
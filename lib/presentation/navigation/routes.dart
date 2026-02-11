import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moneyplus/presentation/home/screen/home_screen.dart';
import 'package:moneyplus/presentation/login/screen/login_screen.dart';
import '../../core/di/injection.dart';
import '../login/cubit/login_cubit.dart';
import '../statistics/cubit/statistics_cubit.dart';
import '../statistics/statistics_screen.dart';
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
            ElevatedButton(onPressed: (){ StatisticsRoute().push(context);}, child: Text("Go to Login"))
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

@TypedGoRoute<HomeRoute>(path: '/home')
@immutable
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return HomeScreen();
  }
}

@TypedGoRoute<StatisticsRoute>(path: '/statistics')
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
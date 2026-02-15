// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$onBoardingRoute, $loginRoute, $mainRoute, $transactionDetailsRoute,];

RouteBase get $onBoardingRoute =>

    GoRouteData.$route(path: '/', factory: $OnBoardingRoute._fromState);

mixin $OnBoardingRoute on GoRouteData {
  static OnBoardingRoute _fromState(GoRouterState state) =>
      const OnBoardingRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $loginRoute =>
    GoRouteData.$route(path: '/login', factory: $LoginRoute._fromState);

mixin $LoginRoute on GoRouteData {
  static LoginRoute _fromState(GoRouterState state) => const LoginRoute();

  @override
  String get location => GoRouteData.$location('/login');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mainRoute =>
    GoRouteData.$route(path: '/main', factory: $MainRoute._fromState);

mixin $MainRoute on GoRouteData {
  static MainRoute _fromState(GoRouterState state) => const MainRoute();

  @override
  String get location => GoRouteData.$location('/main');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $transactionDetailsRoute => GoRouteData.$route(
  path: '/transaction_details',
  factory: $TransactionDetailsRoute._fromState,
);

mixin $TransactionDetailsRoute on GoRouteData {
  static TransactionDetailsRoute _fromState(GoRouterState state) =>
      TransactionDetailsRoute(state.uri.queryParameters['transaction-id']!);

  TransactionDetailsRoute get _self => this as TransactionDetailsRoute;

  @override
  String get location => GoRouteData.$location(
    '/transaction_details',
    queryParams: {'transaction-id': _self.transactionId},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $addIncomeRoute =>
    GoRouteData.$route(path: '/add-income', factory: $AddIncomeRoute._fromState);

mixin $AddIncomeRoute on GoRouteData {
  static AddIncomeRoute _fromState(GoRouterState state) => const AddIncomeRoute();

  @override
  String get location => GoRouteData.$location('/add-income');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $addExpenseRoute =>
    GoRouteData.$route(path: '/add-expense', factory: $AddExpenseRoute._fromState);

mixin $AddExpenseRoute on GoRouteData {
  static AddExpenseRoute _fromState(GoRouterState state) => const AddExpenseRoute();

  @override
  String get location => GoRouteData.$location('/add-expense');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

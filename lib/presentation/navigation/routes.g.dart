// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $onBoardingRoute,
  $loginRoute,
  $mainRoute,
  $transactionDetailsRoute,
  $statisticsRoute,
  $createAccountRoute
  $forgetPasswordRoute,
  $updatePasswordRoute,
];

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

RouteBase get $statisticsRoute => GoRouteData.$route(
  path: '/statistics',
  factory: $StatisticsRoute._fromState,
);

mixin $StatisticsRoute on GoRouteData {
  static StatisticsRoute _fromState(GoRouterState state) =>
      const StatisticsRoute();

  @override
  String get location => GoRouteData.$location('/statistics');

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

RouteBase get $forgetPasswordRoute => GoRouteData.$route(
  path: '/forget_password',
  factory: $ForgetPasswordRoute._fromState,
);

mixin $ForgetPasswordRoute on GoRouteData {
  static ForgetPasswordRoute _fromState(GoRouterState state) =>
      const ForgetPasswordRoute();

  @override
  String get location => GoRouteData.$location('/forget_password');

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

RouteBase get $updatePasswordRoute => GoRouteData.$route(
  path: '/update_password',
  factory: $UpdatePasswordRoute._fromState,
);

mixin $UpdatePasswordRoute on GoRouteData {
  static UpdatePasswordRoute _fromState(GoRouterState state) =>
      UpdatePasswordRoute();

  @override
  String get location => GoRouteData.$location('/update_password');

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

RouteBase get $createAccountRoute =>
    GoRouteData.$route(path: '/createAccount', factory: $CreateAccountRoute._fromState);

mixin $CreateAccountRoute on GoRouteData {
  static $CreateAccountRoute _fromState(GoRouterState state) =>
      const CreateAccountRoute();

  @override
  String get location => GoRouteData.$location('/createAccount');

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

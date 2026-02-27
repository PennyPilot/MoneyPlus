import 'package:moneyplus/domain/repository/account_repository.dart';
import 'package:moneyplus/domain/repository/authentication_repository.dart';
import 'package:moneyplus/domain/repository/statistics_repository.dart';
import 'package:moneyplus/domain/repository/transaction_repository.dart';
import 'package:moneyplus/domain/repository/user_money_repository.dart';
import 'package:moneyplus/domain/validator/authentication_validator.dart';
import 'package:moneyplus/presentation/account_setup/cubit/account_setup_cubit.dart';
import 'package:moneyplus/presentation/createAccount/cubit/create_account_cubit.dart';
import 'package:moneyplus/presentation/home/cubit/home_cubit.dart';
import 'package:moneyplus/presentation/income/cubit/add_income_cubit.dart';
import 'package:moneyplus/presentation/login/cubit/login_cubit.dart';
import 'package:moneyplus/presentation/statistics/cubit/statistics_cubit.dart';
import 'package:moneyplus/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:moneyplus/presentation/trasnaction_details/trasnaction_details_cubit.dart';

import '../../presentation/accout/cubit/account_cubit.dart';
import '../../presentation/expense/cubit/add_expense_cubit.dart';
import 'injection.dart';

void initCubitDI() {
  getIt.registerLazySingleton<AuthenticationValidator>(
    () => AuthenticationValidator(),
  );

  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(userMoneyRepository: getIt<UserMoneyRepository>()),
  );

  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(
      authRepository: getIt<AuthenticationRepository>(),
      validator: getIt<AuthenticationValidator>(),
    ),
  );

  getIt.registerLazySingleton<AccountSetupCubit>(
    () => AccountSetupCubit(getIt<AccountRepository>()),
  );

  getIt.registerFactory<AddExpenseCubit>(
    () => AddExpenseCubit(
      transactionRepository: getIt<TransactionRepository>(),
      userMoneyRepository: getIt<UserMoneyRepository>(),
    ),
  );
  getIt.registerFactory<AddIncomeCubit>(
    () => AddIncomeCubit(
      transactionRepository: getIt<TransactionRepository>(),
      userMoneyRepository: getIt<UserMoneyRepository>(),
    ),
  );

  getIt.registerFactory<TransactionCubit>(
    () =>
        TransactionCubit(transactionRepository: getIt<TransactionRepository>()),
  );

  getIt.registerFactory<StatisticsCubit>(
    () => StatisticsCubit(repository: getIt<StatisticsRepository>()),
  );

  getIt.registerFactory<TransactionDetailsCubit>(
    () => TransactionDetailsCubit(
      transactionRepository: getIt<TransactionRepository>(),
    ),
  );

  getIt.registerFactory<CreateAccountCubit>(
    () => CreateAccountCubit(
      getIt<AuthenticationValidator>(),
      getIt<AuthenticationRepository>(),
    ),
  );
  getIt.registerFactory<AccountCubit>(
        () => AccountCubit(getIt<AccountRepository>()),
  );
}

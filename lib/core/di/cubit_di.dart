import 'package:moneyplus/presentation/account/cubit/currency_selection_cubit.dart';
import 'package:moneyplus/domain/entity/transaction_type.dart';
import 'package:moneyplus/presentation/currency/cubit/currency_rates_cubit.dart';
import 'package:moneyplus/presentation/manage_transaction/cubit/manage_transaction_cubit.dart';
import 'package:moneyplus/domain/repository/account_repository.dart';
import 'package:moneyplus/domain/repository/authentication_repository.dart';
import 'package:moneyplus/domain/repository/statistics_repository.dart';
import 'package:moneyplus/domain/repository/transaction_repository.dart';
import 'package:moneyplus/domain/repository/user_money_repository.dart';
import 'package:moneyplus/domain/validator/authentication_validator.dart';
import 'package:moneyplus/presentation/account_setup/cubit/account_setup_cubit.dart';
import 'package:moneyplus/presentation/createAccount/cubit/create_account_cubit.dart';
import 'package:moneyplus/presentation/edit_salary/salary_settings_cubit.dart';
import 'package:moneyplus/presentation/home/cubit/home_cubit.dart';
import 'package:moneyplus/presentation/income/cubit/add_income_cubit.dart';
import 'package:moneyplus/presentation/login/cubit/login_cubit.dart';
import 'package:moneyplus/presentation/statistics/cubit/statistics_cubit.dart';
import 'package:moneyplus/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:moneyplus/presentation/trasnaction_details/trasnaction_details_cubit.dart';

import '../../domain/repository/category_repository.dart';
import '../../presentation/account/cubit/account_cubit.dart';
import '../../presentation/categories/cubit/categories_cubit.dart';
import '../../presentation/expense/cubit/add_expense_cubit.dart';
import '../../presentation/profileSetting/cubit/profile_settings_cubit.dart';
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

  getIt.registerFactory<AccountSetupCubit>(
    () => AccountSetupCubit(
      getIt<AccountRepository>(),
      getIt<AuthenticationRepository>(),
    ),
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
      getIt<AuthenticationValidator>(),),
  );

  getIt.registerFactory<ProfileSettingsCubit>(
    () => ProfileSettingsCubit(
      getIt<AuthenticationValidator>(),
      getIt<AuthenticationRepository>(),
      getIt<AccountRepository>(),
    ),
  );

  getIt.registerFactory<AccountCubit>(
    () => AccountCubit(getIt<AccountRepository>(), getIt<AuthenticationRepository>()),
  );

  getIt.registerFactory<CurrencySelectionCubit>(
    () => CurrencySelectionCubit(getIt<AccountRepository>()),
  );

  getIt.registerFactory<CategoriesCubit>(
    () => CategoriesCubit(getIt<CategoryRepository>()),
);
  getIt.registerFactory<SalarySettingsCubit>(
    () => SalarySettingsCubit(userMoneyRepository: getIt<UserMoneyRepository>()),
  );

  getIt.registerFactory<CurrencyRatesCubit>(
    () => CurrencyRatesCubit(
      transactionRepository: getIt<TransactionRepository>(),
      userMoneyRepository: getIt<UserMoneyRepository>(),
      accountRepository: getIt<AccountRepository>(),
    ),
  );

  getIt.registerFactoryParam<ManageTransactionCubit, TransactionType, String?>(
    (type, id) => ManageTransactionCubit(
      transactionRepository: getIt<TransactionRepository>(),
      userMoneyRepository: getIt<UserMoneyRepository>(),
      accountRepository: getIt<AccountRepository>(),
      initialType: type,
      transactionId: id,
    ),
  );
}

import 'package:get_it/get_it.dart';
import 'package:moneyplus/core/di/cubit_di.dart';
import 'package:moneyplus/core/di/repository_di.dart';
import 'package:moneyplus/core/di/service_di.dart';

final getIt = GetIt.instance;

void initDI()  {
  initServiceDI();
  initRepositoryDI();
  initCubitDI();
}

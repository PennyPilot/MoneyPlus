import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/repository/authentication_repository.dart';
import '../domain/repository/authentication_repository.dart';
import '../presentation/home/cubit/home_cubit.dart';
import '../presentation/login/cubit/login_cubit.dart';

final getIt = GetIt.instance;

Future<void> initDI() async {
  getIt.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImp(),
  );
  await dotenv.load(fileName: "secrets.env");
  getIt.registerSingleton<Supabase>(
    await Supabase.initialize(
      url: dotenv.env['SUPA_BASE_URL'] ?? "",
      anonKey: dotenv.env['SUPA_API_KEY'] ?? "",
      debug: true,
    ),
  );
  getIt.registerFactory<LoginCubit>(() => LoginCubit());
  getIt.registerFactory<HomeCubit>(() => HomeCubit());
}

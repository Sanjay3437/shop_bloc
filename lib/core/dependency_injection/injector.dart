import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_bloc/core/constants/endpoints.dart';
import 'package:shop_bloc/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:shop_bloc/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:shop_bloc/features/auth/domain/repositories/auth_repository.dart';
import 'package:shop_bloc/features/auth/domain/use_case/get_current_user.dart';
import 'package:shop_bloc/features/auth/domain/use_case/sign_in.dart';
import 'package:shop_bloc/features/auth/domain/use_case/sign_out.dart';
import 'package:shop_bloc/features/auth/domain/use_case/sign_up.dart';
import 'package:shop_bloc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shop_bloc/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:shop_bloc/features/product/data/datasource/product_remote_data_source.dart';
import 'package:shop_bloc/features/product/data/repositories/product_repository_impl.dart';
import 'package:shop_bloc/features/product/domain/repositories/product_repository.dart';
import 'package:shop_bloc/features/product/domain/use_case/get_products.dart';
import 'package:shop_bloc/features/product/presentation/bloc/product_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  sl.registerLazySingleton<Dio>(
        () => Dio(
      BaseOptions(
        baseUrl: Endpoints.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    ),
  );

  // Data
  sl.registerLazySingleton<ProductRemoteDataSource>(
        () => ProductRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProductRepository>(
        () => ProductRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(sl()),
  );

  // Domain
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  // Presentation (factory: a fresh bloc each time)
  sl.registerFactory(() => ProductBloc(getProducts: sl()));
  sl.registerFactory(() => CartBloc());
  sl.registerFactory(
        () => AuthBloc(
      getCurrentUser: sl(),
      signIn: sl(),
      signUp: sl(),
      signOut: sl(),
    ),
  );
}
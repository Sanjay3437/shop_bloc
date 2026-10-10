
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'package:shop_bloc/core/constants/endpoints.dart';
import 'package:shop_bloc/core/network/dio_network_service.dart';
import 'package:shop_bloc/core/network/network_service.dart';

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
import 'package:shop_bloc/features/product/data/datasource/category_remote_data_source.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Secure Storage
  sl.registerLazySingleton<FlutterSecureStorage>(
        () => const FlutterSecureStorage(),
  );

  // Network
  sl.registerLazySingleton<Dio>(
        () => Dio(
      BaseOptions(
        baseUrl: Endpoints.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    ),
  );

  sl.registerLazySingleton<NetworkService>(
        () => DioNetworkService(sl<Dio>()),
  );

  // Data sources
  sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(
      sl<FlutterSecureStorage>(),
    ),
  );

  sl.registerLazySingleton<ProductRemoteDataSource>(
        () => ProductRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<CategoryRemoteDataSource>(
        () => CategoryRemoteDataSourceImpl(sl<NetworkService>()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(sl<AuthLocalDataSource>()),
  );

  sl.registerLazySingleton<ProductRepository>(
        () => ProductRepositoryImpl(sl<ProductRemoteDataSource>()),
  );

  // Domain use cases
  sl.registerLazySingleton(() => GetProducts(sl<ProductRepository>()));
  sl.registerLazySingleton(() => SignIn(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignUp(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignOut(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetCurrentUser(sl<AuthRepository>()));

  // Presentation
  sl.registerFactory(
        () => ProductBloc(getProducts: sl<GetProducts>()),
  );

  sl.registerFactory(() => CartBloc());

  sl.registerFactory(
        () => AuthBloc(
      getCurrentUser: sl<GetCurrentUser>(),
      signIn: sl<SignIn>(),
      signUp: sl<SignUp>(),
      signOut: sl<SignOut>(),
    ),
  );
}
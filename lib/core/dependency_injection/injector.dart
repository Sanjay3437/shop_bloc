import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shop_bloc/core/constants/endpoints.dart';
import 'package:shop_bloc/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:shop_bloc/features/product/data/datasource/product_remote_data_source.dart';
import 'package:shop_bloc/features/product/data/repositories/product_repository_impl.dart';
import 'package:shop_bloc/features/product/domain/repositories/product_repository.dart';
import 'package:shop_bloc/features/product/domain/use_case/get_products.dart';
import 'package:shop_bloc/features/product/presentation/bloc/product_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
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

  // Domain
  sl.registerLazySingleton(() => GetProducts(sl()));

  // Presentation (factory: a fresh bloc each time)
  sl.registerFactory(() => ProductBloc(getProducts: sl()));
  sl.registerFactory(() => CartBloc());
}
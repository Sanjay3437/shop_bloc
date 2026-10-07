import 'package:dartz/dartz.dart';
import 'package:shop_bloc/core/exceptions/failures.dart';
import 'package:shop_bloc/core/utils/use_case.dart';

import '../entities/product.dart';
import '../repositories/product_repository.dart';

class ProductParams {
  final int page;
  final int limit;
  final String? category;

  const ProductParams({
    required this.page,
    required this.limit,
    this.category,
  });
}

class GetProducts implements UseCase<List<Product>, ProductParams> {
  final ProductRepository repository;

  const GetProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(
      ProductParams params,
      ) {
    return repository.getProducts(
      page: params.page,
      limit: params.limit,
      category: params.category,
    );
  }
}
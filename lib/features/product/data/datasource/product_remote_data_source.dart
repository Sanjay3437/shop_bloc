import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shop_bloc/core/exceptions/app_exceptions.dart';

import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    required int page,
    required int limit,
    String? category,
  });
}

class ProductRemoteDataSourceImpl
    implements ProductRemoteDataSource {

  @override
  Future<List<ProductModel>> getProducts({
    required int page,
    required int limit,
    String? category,
  }) async {
    try {
      final String raw =
      await rootBundle.loadString(
        'assets/data/products.json',
      );

      final json = jsonDecode(raw)
      as Map<String, dynamic>;

      final data = json['products']
      as List<dynamic>;

      final products = data
          .map(
            (e) => ProductModel.fromJson(
          e as Map<String, dynamic>,
        ),
      )
          .toList();


      final filteredProducts = category == null
          ? products
          : products
          .where(
            (product) =>
        product.category.toLowerCase() ==
            category.toLowerCase(),
      )
          .toList();


      final startIndex =
          (page - 1) * limit;

      if (startIndex >=
          filteredProducts.length) {
        return [];
      }

      final endIndex =
      (startIndex + limit)
          .clamp(
        0,
        filteredProducts.length,
      );

      return filteredProducts.sublist(
        startIndex,
        endIndex,
      );
    } catch (e) {
      print('PRODUCT ERROR: $e');

      throw ServerException(
        'Failed to load products from local data',
      );
    }
  }
}
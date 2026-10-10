import 'package:shop_bloc/core/exceptions/app_exceptions.dart';
import 'package:shop_bloc/core/network/network_service.dart';

abstract class CategoryRemoteDataSource {
  Future<List<String>> getCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final NetworkService networkService;

  const CategoryRemoteDataSourceImpl(this.networkService);

  @override
  Future<List<String>> getCategories() async {
    try {
      final data = await networkService.get('/products/categories')
      as List<dynamic>;
      return data.map((e) => e.toString()).toList();
    } on NetworkException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch categories: $e');
    }
  }
}
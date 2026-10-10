import 'package:dio/dio.dart';
import 'package:shop_bloc/core/exceptions/app_exceptions.dart';
import 'network_service.dart';

class DioNetworkService implements NetworkService {
  final Dio dio;

  const DioNetworkService(this.dio);

  dynamic _handleResponse(Response response) {
    return response.data;
  }

  @override
  Future<dynamic> get(
      String path, {
        Map<String, dynamic>? queryParameters,
      }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<dynamic> post(
      String path, {
        Map<String, dynamic>? data,
      }) async {
    try {
      final response = await dio.post(path, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<dynamic> put(
      String path, {
        Map<String, dynamic>? data,
      }) async {
    try {
      final response = await dio.put(path, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<dynamic> delete(String path) async {
    try {
      final response = await dio.delete(path);
      return _handleResponse(response);
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  Never _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw const NetworkException();
      default:
        throw ServerException(
          e.message ?? 'Something went wrong',
          statusCode: e.response?.statusCode,
        );
    }
  }
}
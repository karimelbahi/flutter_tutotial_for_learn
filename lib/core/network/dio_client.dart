import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import '../errors/exceptions.dart';

/// Singleton HTTP client for all TMDB API calls.
///
/// Usage in datasources:
/// ```dart
/// final response = await DioClient.instance.get('/movie/popular', queryParameters: {...});
/// ```
class DioClient {
  DioClient._();

  static final DioClient instance = DioClient._();

  late final Dio _dio;
  var _isConfigured = false;

  Dio get dio {
    if (!_isConfigured) {
      throw StateError('DioClient is not configured. Call configure() first.');
    }
    return _dio;
  }

  /// Call once at app startup after [dotenv] is loaded.
  void configure() {
    if (_isConfigured) return;

    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        headers: const {
          'Accept': 'application/json',
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
        ),
      );
    }

    _isConfigured = true;
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await dio.get<T>(path, queryParameters: queryParameters);
    } on DioException catch (error) {
      throw _mapException(error);
    }
  }

  Exception _mapException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkException(error.message ?? 'Connection failed');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        return ServerException(
          'Request failed with status $statusCode',
        );
      default:
        return ServerException(error.message ?? 'Unexpected error');
    }
  }
}

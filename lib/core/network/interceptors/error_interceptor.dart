import 'package:dio/dio.dart';

import '../../errors/exceptions.dart';

/// Maps Dio errors to typed exceptions before they reach the repository.
///
/// Retrofit uses Dio under the hood — this interceptor keeps error handling
/// in one place so datasources stay clean.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError =>
        NetworkException(err.message ?? 'Connection failed'),
      DioExceptionType.badResponse => ServerException(
          'Request failed with status ${err.response?.statusCode}',
        ),
      _ => ServerException(err.message ?? 'Unexpected error'),
    };

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: exception,
        type: err.type,
        response: err.response,
      ),
    );
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import 'interceptors/error_interceptor.dart';

/// Creates the shared [Dio] instance used as Retrofit's HTTP engine.
///
/// Retrofit builds on Dio internally — we configure Dio once here,
/// then pass it to [TmdbApi] in the movies feature data layer.
class DioFactory {
  DioFactory._();

  static final DioFactory instance = DioFactory._();

  late final Dio dio;
  var _isConfigured = false;

  void configure() {
    if (_isConfigured) return;

    dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        headers: const {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(ErrorInterceptor());

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }

    _isConfigured = true;
  }

  Dio get client {
    if (!_isConfigured) {
      throw StateError('DioFactory is not configured. Call configure() first.');
    }
    return dio;
  }
}

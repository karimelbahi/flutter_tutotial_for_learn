import '../../../../core/config/app_config.dart';
import '../../../../core/network/dio_factory.dart';
import 'tmdb_api.dart';

/// Provides the Retrofit [TmdbApi] client for the movies feature.
///
/// Depends on [DioFactory] being configured first in main.dart.
class TmdbApiProvider {
  TmdbApiProvider._();

  static final TmdbApiProvider instance = TmdbApiProvider._();

  late final TmdbApi api;
  var _isConfigured = false;

  void configure() {
    if (_isConfigured) return;

    api = TmdbApi(
      DioFactory.instance.client,
      baseUrl: AppConfig.baseUrl,
    );
    _isConfigured = true;
  }

  TmdbApi get client {
    if (!_isConfigured) {
      throw StateError('TmdbApiProvider is not configured. Call configure() first.');
    }
    return api;
  }
}

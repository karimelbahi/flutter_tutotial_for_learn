import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class AppConfig {
  static String get apiKey => _require('API_KEY');
  static String get baseUrl => _require('BASE_URL');
  static String get imageBaseUrl => _require('IMAGE_URL');

  static String imageUrl(String path) => '$imageBaseUrl$path';

  static String get popularMoviesUrl =>
      '$baseUrl/movie/popular?api_key=$apiKey&page=1';

  static String get topRatedMoviesUrl =>
      '$baseUrl/movie/top_rated?api_key=$apiKey&language=en-US&page=1';

  static String get upcomingMoviesUrl =>
      '$baseUrl/movie/upcoming?api_key=$apiKey&language=en-US&page=1';

  static String genreMoviesUrl(int genreId) =>
      '$baseUrl/discover/movie?api_key=$apiKey&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_genres=$genreId';

  static String searchMoviesUrl(String query) =>
      '$baseUrl/search/movie?api_key=$apiKey&language=en-US&page=1&include_adult=false&query=$query';

  static String movieDetailUrl(int movieId) =>
      '$baseUrl/movie/$movieId?api_key=$apiKey&append_to_response=images';

  static String movieCreditsUrl(int movieId) =>
      '$baseUrl/movie/$movieId/credits?api_key=$apiKey';

  static String similarMoviesUrl(int movieId) =>
      '$baseUrl/movie/$movieId/similar?api_key=$apiKey&page=1';

  static String _require(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw StateError('Missing $key in .env file');
    }
    return value;
  }
}

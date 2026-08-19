import '../models/movie_model.dart';

/// TMDB paginated list response: `{ "results": [ {...}, ... ] }`
///
/// Retrofit deserializes JSON into this class via [fromJson].
class TmdbMoviesResponse {
  const TmdbMoviesResponse({required this.results});

  final List<MovieModel> results;

  factory TmdbMoviesResponse.fromJson(Map<String, dynamic> json) {
    final rawResults = json['results'] as List<dynamic>? ?? [];
    return TmdbMoviesResponse(
      results: rawResults
          .map((item) => MovieModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

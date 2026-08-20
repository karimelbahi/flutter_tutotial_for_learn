import '../../../../core/config/app_config.dart';
import '../api/tmdb_api.dart';
import '../api/tmdb_api_provider.dart';
import '../models/movie_credits_model.dart';
import '../models/movie_detail_model.dart';
import '../models/movie_model.dart';

/// Fetches movie lists from TMDB via the Retrofit [TmdbApi] client.
///
/// **Data layer** — calls typed Retrofit methods, not raw HTTP.
/// Returns [MovieModel] (not [Movie]) because JSON mapping belongs here.
abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> fetchPopularMovies();

  Future<List<MovieModel>> fetchMoviesByGenre(int genreId);

  Future<List<MovieModel>> fetchTopRatedMovies();

  Future<List<MovieModel>> fetchUpcomingMovies();

  Future<List<MovieModel>> fetchSearchMovies(String query);

  Future<MovieDetailModel> fetchMovieDetail(int movieId);

  Future<List<CastMemberModel>> fetchMovieCast(int movieId);

  Future<List<MovieModel>> fetchSimilarMovies(int movieId);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  MovieRemoteDataSourceImpl({TmdbApi? api})
      : _api = api ?? TmdbApiProvider.instance.client;

  final TmdbApi _api;

  static const _page = 1;
  static const _language = 'en-US';

  @override
  Future<List<MovieModel>> fetchPopularMovies() async {
    final response = await _api.getPopularMovies(
      AppConfig.apiKey,
      _page,
      _language,
    );
    return response.results;
  }

  @override
  Future<List<MovieModel>> fetchMoviesByGenre(int genreId) async {
    final response = await _api.getMoviesByGenre(
      AppConfig.apiKey,
      _page,
      _language,
      genreId,
      'popularity.desc',
      false,
      false,
    );
    return response.results;
  }

  @override
  Future<List<MovieModel>> fetchTopRatedMovies() async {
    final response = await _api.getTopRatedMovies(
      AppConfig.apiKey,
      _page,
      _language,
    );
    return response.results;
  }

  @override
  Future<List<MovieModel>> fetchUpcomingMovies() async {
    final response = await _api.getUpcomingMovies(
      AppConfig.apiKey,
      _page,
      _language,
    );
    return response.results;
  }

  @override
  Future<List<MovieModel>> fetchSearchMovies(String query) async {
    final response = await _api.searchMovies(
      AppConfig.apiKey,
      query,
      _page,
      _language,
      false,
    );
    return response.results;
  }

  @override
  Future<MovieDetailModel> fetchMovieDetail(int movieId) async {
    return _api.getMovieDetail(
      movieId,
      AppConfig.apiKey,
      'images',
    );
  }

  @override
  Future<List<CastMemberModel>> fetchMovieCast(int movieId) async {
    final response = await _api.getMovieCredits(
      movieId,
      AppConfig.apiKey,
    );
    return response.cast;
  }

  @override
  Future<List<MovieModel>> fetchSimilarMovies(int movieId) async {
    final response = await _api.getSimilarMovies(
      movieId,
      AppConfig.apiKey,
      _page,
    );
    return response.results;
  }
}

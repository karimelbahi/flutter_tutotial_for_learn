import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/movie_credits_model.dart';
import '../models/movie_detail_model.dart';
import '../models/tmdb_movies_response.dart';

part 'tmdb_api.g.dart';

/// Retrofit API interface for TMDB movie list endpoints.
///
/// Generated implementation lives in `tmdb_api.g.dart`.
/// Regenerate: `dart run build_runner build --delete-conflicting-outputs`
@RestApi()
abstract class TmdbApi {
  factory TmdbApi(Dio dio, {String? baseUrl}) = _TmdbApi;

  @GET('/movie/popular')
  Future<TmdbMoviesResponse> getPopularMovies(
    @Query('api_key') String apiKey,
    @Query('page') int page,
    @Query('language') String language,
  );

  @GET('/discover/movie')
  Future<TmdbMoviesResponse> getMoviesByGenre(
    @Query('api_key') String apiKey,
    @Query('page') int page,
    @Query('language') String language,
    @Query('with_genres') int genreId,
    @Query('sort_by') String sortBy,
    @Query('include_adult') bool includeAdult,
    @Query('include_video') bool includeVideo,
  );

  @GET('/movie/top_rated')
  Future<TmdbMoviesResponse> getTopRatedMovies(
    @Query('api_key') String apiKey,
    @Query('page') int page,
    @Query('language') String language,
  );

  @GET('/movie/upcoming')
  Future<TmdbMoviesResponse> getUpcomingMovies(
    @Query('api_key') String apiKey,
    @Query('page') int page,
    @Query('language') String language,
  );

  /// TMDB movie search — used by the search screen (spec 002).
  @GET('/search/movie')
  Future<TmdbMoviesResponse> searchMovies(
    @Query('api_key') String apiKey,
    @Query('query') String query,
    @Query('page') int page,
    @Query('language') String language,
    @Query('include_adult') bool includeAdult,
  );

  /// Movie detail with backdrop images — spec 003-movie-detail.
  @GET('/movie/{movie_id}')
  Future<MovieDetailModel> getMovieDetail(
    @Path('movie_id') int movieId,
    @Query('api_key') String apiKey,
    @Query('append_to_response') String appendToResponse,
  );

  @GET('/movie/{movie_id}/credits')
  Future<MovieCreditsModel> getMovieCredits(
    @Path('movie_id') int movieId,
    @Query('api_key') String apiKey,
  );

  @GET('/movie/{movie_id}/similar')
  Future<TmdbMoviesResponse> getSimilarMovies(
    @Path('movie_id') int movieId,
    @Query('api_key') String apiKey,
    @Query('page') int page,
  );
}

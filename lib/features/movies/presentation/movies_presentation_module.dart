import '../data/repositories/movie_repository_impl.dart';
import '../domain/entities/genre.dart';
import '../domain/usecases/get_genre_movies.dart';
import '../domain/usecases/get_popular_movies.dart';
import '../domain/usecases/get_movie_cast.dart';
import '../domain/usecases/get_movie_detail.dart';
import '../domain/usecases/get_similar_movies.dart';
import '../domain/usecases/get_top_rated_movies.dart';
import '../domain/usecases/get_upcoming_movies.dart';
import '../domain/usecases/search_movies.dart';
import 'cubit/genre_movies_cubit.dart';
import 'cubit/movie_cast_cubit.dart';
import 'cubit/movie_detail_cubit.dart';
import 'cubit/popular_movies_cubit.dart';
import 'cubit/search_movies_cubit.dart';
import 'cubit/similar_movies_cubit.dart';
import 'cubit/top_rated_movies_cubit.dart';
import 'cubit/upcoming_movies_cubit.dart';

/// Shared repository instance for home-screen cubits (Step 4+).
MovieRepositoryImpl _sharedMovieRepository() => MovieRepositoryImpl();

PopularMoviesCubit createPopularMoviesCubit() {
  final repository = _sharedMovieRepository();
  return PopularMoviesCubit(GetPopularMovies(repository));
}

GenreMoviesCubit createGenreMoviesCubit() {
  final repository = _sharedMovieRepository();
  final initialGenreId = kMovieGenres.first.id;
  return GenreMoviesCubit(
    GetGenreMovies(repository),
    initialGenreId: initialGenreId,
  )..load(initialGenreId);
}

TopRatedMoviesCubit createTopRatedMoviesCubit() {
  final repository = _sharedMovieRepository();
  return TopRatedMoviesCubit(GetTopRatedMovies(repository));
}

UpcomingMoviesCubit createUpcomingMoviesCubit() {
  final repository = _sharedMovieRepository();
  return UpcomingMoviesCubit(GetUpcomingMovies(repository));
}

SearchMoviesCubit createSearchMoviesCubit() {
  final repository = _sharedMovieRepository();
  return SearchMoviesCubit(SearchMovies(repository));
}

MovieDetailCubit createMovieDetailCubit() {
  final repository = _sharedMovieRepository();
  return MovieDetailCubit(GetMovieDetail(repository));
}

MovieCastCubit createMovieCastCubit() {
  final repository = _sharedMovieRepository();
  return MovieCastCubit(GetMovieCast(repository));
}

SimilarMoviesCubit createSimilarMoviesCubit() {
  final repository = _sharedMovieRepository();
  return SimilarMoviesCubit(GetSimilarMovies(repository));
}

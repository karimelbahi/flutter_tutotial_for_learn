import '../data/repositories/movie_repository_impl.dart';
import '../domain/entities/genre.dart';
import '../domain/usecases/get_genre_movies.dart';
import '../domain/usecases/get_popular_movies.dart';
import 'cubit/genre_movies_cubit.dart';
import 'cubit/popular_movies_cubit.dart';

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

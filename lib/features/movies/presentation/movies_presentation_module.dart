import '../data/repositories/movie_repository_impl.dart';
import '../domain/usecases/get_popular_movies.dart';
import 'cubit/popular_movies_cubit.dart';

/// Simple factory for presentation-layer dependencies (Step 4).
///
/// Later steps can expand this or move to a dedicated DI package.
/// Keeps [MovieHomeScreen] free of `new RepositoryImpl()` noise.
PopularMoviesCubit createPopularMoviesCubit() {
  final repository = MovieRepositoryImpl();
  final getPopularMovies = GetPopularMovies(repository);
  return PopularMoviesCubit(getPopularMovies);
}

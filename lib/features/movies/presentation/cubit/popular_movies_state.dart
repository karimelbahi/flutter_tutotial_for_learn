import 'package:equatable/equatable.dart';

import '../../domain/entities/movie.dart';

/// States for the home popular-movies carousel (Step 4).
///
/// Naming follows project constitution: Initial → Loading → Success → Failure.
sealed class PopularMoviesState extends Equatable {
  const PopularMoviesState();

  @override
  List<Object?> get props => [];
}

final class PopularMoviesInitial extends PopularMoviesState {
  const PopularMoviesInitial();
}

final class PopularMoviesLoading extends PopularMoviesState {
  const PopularMoviesLoading();
}

final class PopularMoviesSuccess extends PopularMoviesState {
  const PopularMoviesSuccess(
    this.movies, {
    this.isStale = false,
    this.isRefreshing = false,
  });

  final List<Movie> movies;

  /// `true` when network refresh failed but cached data is still shown.
  final bool isStale;

  /// `true` while a background TMDB refresh is in flight.
  final bool isRefreshing;

  @override
  List<Object?> get props => [movies, isStale, isRefreshing];
}

final class PopularMoviesFailure extends PopularMoviesState {
  const PopularMoviesFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

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
  const PopularMoviesSuccess(this.movies);

  final List<Movie> movies;

  @override
  List<Object?> get props => [movies];
}

final class PopularMoviesFailure extends PopularMoviesState {
  const PopularMoviesFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

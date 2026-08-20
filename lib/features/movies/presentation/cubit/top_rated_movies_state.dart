import 'package:equatable/equatable.dart';

import '../../domain/entities/movie.dart';

/// States for the home top-rated movies row (Step 6).
sealed class TopRatedMoviesState extends Equatable {
  const TopRatedMoviesState();

  @override
  List<Object?> get props => [];
}

final class TopRatedMoviesInitial extends TopRatedMoviesState {
  const TopRatedMoviesInitial();
}

final class TopRatedMoviesLoading extends TopRatedMoviesState {
  const TopRatedMoviesLoading();
}

final class TopRatedMoviesSuccess extends TopRatedMoviesState {
  const TopRatedMoviesSuccess(
    this.movies, {
    this.isStale = false,
    this.isRefreshing = false,
  });

  final List<Movie> movies;
  final bool isStale;
  final bool isRefreshing;

  @override
  List<Object?> get props => [movies, isStale, isRefreshing];
}

final class TopRatedMoviesFailure extends TopRatedMoviesState {
  const TopRatedMoviesFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

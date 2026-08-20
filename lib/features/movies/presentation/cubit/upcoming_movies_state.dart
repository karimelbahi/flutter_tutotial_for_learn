import 'package:equatable/equatable.dart';

import '../../domain/entities/movie.dart';

/// States for the home upcoming movies row (Step 7).
sealed class UpcomingMoviesState extends Equatable {
  const UpcomingMoviesState();

  @override
  List<Object?> get props => [];
}

final class UpcomingMoviesInitial extends UpcomingMoviesState {
  const UpcomingMoviesInitial();
}

final class UpcomingMoviesLoading extends UpcomingMoviesState {
  const UpcomingMoviesLoading();
}

final class UpcomingMoviesSuccess extends UpcomingMoviesState {
  const UpcomingMoviesSuccess(
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

final class UpcomingMoviesFailure extends UpcomingMoviesState {
  const UpcomingMoviesFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

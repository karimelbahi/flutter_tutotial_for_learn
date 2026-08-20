import 'package:equatable/equatable.dart';

import '../../domain/entities/movie.dart';

sealed class SimilarMoviesState extends Equatable {
  const SimilarMoviesState();

  @override
  List<Object?> get props => [];
}

final class SimilarMoviesInitial extends SimilarMoviesState {
  const SimilarMoviesInitial();
}

final class SimilarMoviesLoading extends SimilarMoviesState {
  const SimilarMoviesLoading();
}

final class SimilarMoviesSuccess extends SimilarMoviesState {
  const SimilarMoviesSuccess(
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

final class SimilarMoviesFailure extends SimilarMoviesState {
  const SimilarMoviesFailure({
    required this.message,
    required this.movieId,
  });

  final String message;
  final int movieId;

  @override
  List<Object?> get props => [message, movieId];
}

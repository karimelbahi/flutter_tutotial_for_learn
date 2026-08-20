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
  const SimilarMoviesSuccess(this.movies);

  final List<Movie> movies;

  @override
  List<Object?> get props => [movies];
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

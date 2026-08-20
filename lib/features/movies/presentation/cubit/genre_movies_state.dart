import 'package:equatable/equatable.dart';

import '../../domain/entities/movie.dart';

/// States for genre-filtered movie rows on the home screen (Step 5).
sealed class GenreMoviesState extends Equatable {
  const GenreMoviesState({required this.genreId});

  final int genreId;

  @override
  List<Object?> get props => [genreId];
}

final class GenreMoviesInitial extends GenreMoviesState {
  const GenreMoviesInitial({required super.genreId});
}

final class GenreMoviesLoading extends GenreMoviesState {
  const GenreMoviesLoading({required super.genreId});
}

final class GenreMoviesSuccess extends GenreMoviesState {
  const GenreMoviesSuccess({
    required super.genreId,
    required this.movies,
    this.isStale = false,
    this.isRefreshing = false,
  });

  final List<Movie> movies;
  final bool isStale;
  final bool isRefreshing;

  @override
  List<Object?> get props => [genreId, movies, isStale, isRefreshing];
}

final class GenreMoviesFailure extends GenreMoviesState {
  const GenreMoviesFailure({
    required super.genreId,
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [genreId, message];
}

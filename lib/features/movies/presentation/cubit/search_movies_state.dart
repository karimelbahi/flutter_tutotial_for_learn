import 'package:equatable/equatable.dart';

import '../../domain/entities/movie.dart';

/// States for the movie search screen (spec 002).
sealed class SearchMoviesState extends Equatable {
  const SearchMoviesState();

  @override
  List<Object?> get props => [];
}

final class SearchMoviesInitial extends SearchMoviesState {
  const SearchMoviesInitial();
}

final class SearchMoviesLoading extends SearchMoviesState {
  const SearchMoviesLoading({required this.query});

  final String query;

  @override
  List<Object?> get props => [query];
}

final class SearchMoviesSuccess extends SearchMoviesState {
  const SearchMoviesSuccess({
    required this.movies,
    required this.query,
  });

  final List<Movie> movies;
  final String query;

  @override
  List<Object?> get props => [movies, query];
}

final class SearchMoviesEmpty extends SearchMoviesState {
  const SearchMoviesEmpty({required this.query});

  final String query;

  @override
  List<Object?> get props => [query];
}

final class SearchMoviesFailure extends SearchMoviesState {
  const SearchMoviesFailure({
    required this.message,
    required this.query,
  });

  final String message;
  final String query;

  @override
  List<Object?> get props => [message, query];
}

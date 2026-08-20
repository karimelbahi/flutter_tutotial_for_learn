import 'package:equatable/equatable.dart';

import '../../domain/entities/movie_detail.dart';

sealed class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object?> get props => [];
}

final class MovieDetailInitial extends MovieDetailState {
  const MovieDetailInitial();
}

final class MovieDetailLoading extends MovieDetailState {
  const MovieDetailLoading();
}

final class MovieDetailSuccess extends MovieDetailState {
  const MovieDetailSuccess(this.detail);

  final MovieDetail detail;

  @override
  List<Object?> get props => [detail];
}

final class MovieDetailFailure extends MovieDetailState {
  const MovieDetailFailure({
    required this.message,
    required this.movieId,
  });

  final String message;
  final int movieId;

  @override
  List<Object?> get props => [message, movieId];
}

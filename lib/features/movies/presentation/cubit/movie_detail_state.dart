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
  const MovieDetailSuccess(
    this.detail, {
    this.isStale = false,
    this.isRefreshing = false,
  });

  final MovieDetail detail;
  final bool isStale;
  final bool isRefreshing;

  @override
  List<Object?> get props => [detail, isStale, isRefreshing];
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

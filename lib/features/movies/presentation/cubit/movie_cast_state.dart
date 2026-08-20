import 'package:equatable/equatable.dart';

import '../../domain/entities/cast_member.dart';

sealed class MovieCastState extends Equatable {
  const MovieCastState();

  @override
  List<Object?> get props => [];
}

final class MovieCastInitial extends MovieCastState {
  const MovieCastInitial();
}

final class MovieCastLoading extends MovieCastState {
  const MovieCastLoading();
}

final class MovieCastSuccess extends MovieCastState {
  const MovieCastSuccess(
    this.cast, {
    this.isStale = false,
    this.isRefreshing = false,
  });

  final List<CastMember> cast;
  final bool isStale;
  final bool isRefreshing;

  @override
  List<Object?> get props => [cast, isStale, isRefreshing];
}

final class MovieCastFailure extends MovieCastState {
  const MovieCastFailure({
    required this.message,
    required this.movieId,
  });

  final String message;
  final int movieId;

  @override
  List<Object?> get props => [message, movieId];
}

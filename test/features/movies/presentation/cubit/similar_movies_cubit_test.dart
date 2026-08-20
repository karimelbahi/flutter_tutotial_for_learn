import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tutotial_for_learn/core/errors/failures.dart';
import 'package:flutter_tutotial_for_learn/core/utils/result.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/entities/cast_member.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/entities/movie.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/entities/movie_detail.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/repositories/movie_repository.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/usecases/get_similar_movies.dart';
import 'package:flutter_tutotial_for_learn/features/movies/presentation/cubit/similar_movies_cubit.dart';
import 'package:flutter_tutotial_for_learn/features/movies/presentation/cubit/similar_movies_state.dart';

const _similar = [
  Movie(
    id: 807,
    title: 'Se7en',
    voteAverage: 8.3,
    posterPath: '/poster.jpg',
    releaseDate: '1995-09-22',
  ),
];

class _FakeMovieRepository implements MovieRepository {
  _FakeMovieRepository({required this.onGetSimilarMovies});

  final Future<Result<List<Movie>>> Function(int movieId) onGetSimilarMovies;

  @override
  Future<Result<List<Movie>>> getSimilarMovies(int movieId) =>
      onGetSimilarMovies(movieId);

  @override
  Future<Result<MovieDetail>> getMovieDetail(int movieId) =>
      throw UnimplementedError();

  @override
  Future<Result<List<CastMember>>> getMovieCast(int movieId) =>
      throw UnimplementedError();

  @override
  Future<Result<List<Movie>>> getPopularMovies() => throw UnimplementedError();

  @override
  Stream<List<Movie>> watchPopularMovies() => throw UnimplementedError();

  @override
  Future<Result<void>> refreshPopularMovies() => throw UnimplementedError();

  @override
  Future<Result<List<Movie>>> getMoviesByGenre(int genreId) =>
      throw UnimplementedError();

  @override
  Future<Result<List<Movie>>> getTopRatedMovies() => throw UnimplementedError();

  @override
  Future<Result<List<Movie>>> getUpcomingMovies() => throw UnimplementedError();

  @override
  Future<Result<List<Movie>>> searchMovies(String query) =>
      throw UnimplementedError();
}

SimilarMoviesCubit _cubit(
  Future<Result<List<Movie>>> Function(int movieId) handler,
) {
  return SimilarMoviesCubit(
    GetSimilarMovies(_FakeMovieRepository(onGetSimilarMovies: handler)),
  );
}

void main() {
  group('SimilarMoviesCubit', () {
    test('emits success with similar movies', () async {
      final cubit = _cubit((_) async => Success(_similar));
      addTearDown(cubit.close);

      await cubit.load(550);

      expect(cubit.state, isA<SimilarMoviesSuccess>());
      expect((cubit.state as SimilarMoviesSuccess).movies, _similar);
    });

    test('ignores stale response after newer movieId request', () async {
      final slowCompleter = Completer<Result<List<Movie>>>();
      final cubit = _cubit((movieId) async {
        if (movieId == 550) {
          return slowCompleter.future;
        }
        return Success(_similar);
      });
      addTearDown(cubit.close);

      unawaited(cubit.load(550));
      expect(cubit.state, isA<SimilarMoviesLoading>());

      await cubit.load(807);
      expect(cubit.state, isA<SimilarMoviesSuccess>());
      expect((cubit.state as SimilarMoviesSuccess).movies, _similar);

      slowCompleter.complete(Success(_similar));
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, isA<SimilarMoviesSuccess>());
      expect((cubit.state as SimilarMoviesSuccess).movies, _similar);
    });

    test('emits failure on error', () async {
      final cubit = _cubit(
        (_) async => const Error(ServerFailure('Similar unavailable')),
      );
      addTearDown(cubit.close);

      await cubit.load(550);

      expect(cubit.state, isA<SimilarMoviesFailure>());
      expect((cubit.state as SimilarMoviesFailure).message, 'Similar unavailable');
    });
  });
}

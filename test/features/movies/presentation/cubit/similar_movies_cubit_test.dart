import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tutotial_for_learn/core/errors/failures.dart';
import 'package:flutter_tutotial_for_learn/core/utils/result.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/entities/movie.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/usecases/refresh_similar_movies.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/usecases/watch_similar_movies.dart';
import 'package:flutter_tutotial_for_learn/features/movies/presentation/cubit/similar_movies_cubit.dart';
import 'package:flutter_tutotial_for_learn/features/movies/presentation/cubit/similar_movies_state.dart';

import '../../helpers/stub_movie_repository.dart';

const _similar = [
  Movie(
    id: 807,
    title: 'Se7en',
    voteAverage: 8.3,
    posterPath: '/poster.jpg',
    releaseDate: '1995-09-22',
  ),
];

class _FakeMovieRepository extends StubMovieRepository {
  _FakeMovieRepository({
    required this.watchSimilar,
    required this.refreshSimilar,
  });

  final Stream<List<Movie>> Function(int movieId) watchSimilar;
  final Future<Result<void>> Function(int movieId) refreshSimilar;

  @override
  Stream<List<Movie>> watchSimilarMovies(int movieId) =>
      watchSimilar(movieId);

  @override
  Future<Result<void>> refreshSimilarMovies(int movieId) =>
      refreshSimilar(movieId);
}

SimilarMoviesCubit _cubit(_FakeMovieRepository repository) {
  return SimilarMoviesCubit(
    WatchSimilarMovies(repository),
    RefreshSimilarMovies(repository),
  );
}

void main() {
  group('SimilarMoviesCubit — cache-first', () {
    test('emits success with cached similar movies', () async {
      final cubit = _cubit(
        _FakeMovieRepository(
          watchSimilar: (_) => Stream.value(_similar),
          refreshSimilar: (_) async => const Success(null),
        ),
      );
      addTearDown(cubit.close);

      await cubit.load(550);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, isA<SimilarMoviesSuccess>());
      expect((cubit.state as SimilarMoviesSuccess).movies, _similar);
    });

    test('ignores stale response after newer movieId request', () async {
      final slowController = StreamController<List<Movie>>.broadcast();
      final fastController = StreamController<List<Movie>>.broadcast();

      final cubit = _cubit(
        _FakeMovieRepository(
          watchSimilar: (movieId) {
            if (movieId == 550) return slowController.stream;
            return fastController.stream;
          },
          refreshSimilar: (_) async => const Success(null),
        ),
      );
      addTearDown(cubit.close);
      addTearDown(slowController.close);
      addTearDown(fastController.close);

      await cubit.load(550);
      slowController.add(_similar);
      await Future<void>.delayed(Duration.zero);

      await cubit.load(807);
      fastController.add(_similar);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, isA<SimilarMoviesSuccess>());

      slowController.add(_similar);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, isA<SimilarMoviesSuccess>());
      expect((cubit.state as SimilarMoviesSuccess).movies, _similar);
    });

    test('emits failure on error without cache', () async {
      final cubit = _cubit(
        _FakeMovieRepository(
          watchSimilar: (_) => Stream.value(const []),
          refreshSimilar: (_) async =>
              const Error<void>(ServerFailure('Similar unavailable')),
        ),
      );
      addTearDown(cubit.close);

      await cubit.load(550);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, isA<SimilarMoviesFailure>());
      expect((cubit.state as SimilarMoviesFailure).message, 'Similar unavailable');
    });
  });
}

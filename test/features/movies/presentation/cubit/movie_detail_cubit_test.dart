import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tutotial_for_learn/core/errors/failures.dart';
import 'package:flutter_tutotial_for_learn/core/utils/result.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/entities/movie_detail.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/usecases/refresh_movie_detail.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/usecases/watch_movie_detail.dart';
import 'package:flutter_tutotial_for_learn/features/movies/presentation/cubit/movie_detail_cubit.dart';
import 'package:flutter_tutotial_for_learn/features/movies/presentation/cubit/movie_detail_state.dart';

import '../../helpers/stub_movie_repository.dart';

const _detail = MovieDetail(
  id: 550,
  title: 'Fight Club',
  voteAverage: 8.4,
  revenue: 100853753,
  status: 'Released',
  overview: 'A ticking-time-bomb insomniac...',
  posterPath: '/poster.jpg',
  releaseDate: '1999-10-15',
  runtime: 139,
);

class _FakeMovieRepository extends StubMovieRepository {
  _FakeMovieRepository({
    required this.watchDetail,
    required this.refreshDetail,
  });

  final Stream<MovieDetail?> Function(int movieId) watchDetail;
  final Future<Result<void>> Function(int movieId) refreshDetail;

  @override
  Stream<MovieDetail?> watchMovieDetail(int movieId) => watchDetail(movieId);

  @override
  Future<Result<void>> refreshMovieDetail(int movieId) =>
      refreshDetail(movieId);
}

MovieDetailCubit _cubit(_FakeMovieRepository repository) {
  return MovieDetailCubit(
    WatchMovieDetail(repository),
    RefreshMovieDetail(repository),
  );
}

void main() {
  group('MovieDetailCubit — cache-first', () {
    test('shows cached detail without loading flash', () async {
      final cubit = _cubit(
        _FakeMovieRepository(
          watchDetail: (_) => Stream.value(_detail),
          refreshDetail: (_) async => const Success(null),
        ),
      );
      addTearDown(cubit.close);

      final states = <MovieDetailState>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.load(550);
      await Future<void>.delayed(Duration.zero);

      expect(states.any((state) => state is MovieDetailLoading), isFalse);
      expect(cubit.state, isA<MovieDetailSuccess>());
      expect((cubit.state as MovieDetailSuccess).detail, _detail);

      await sub.cancel();
    });

    test('refresh failure with cache marks state as stale', () async {
      final cubit = _cubit(
        _FakeMovieRepository(
          watchDetail: (_) => Stream.value(_detail),
          refreshDetail: (_) async =>
              const Error<void>(NetworkFailure('offline')),
        ),
      );
      addTearDown(cubit.close);

      await cubit.load(550);
      await Future<void>.delayed(Duration.zero);

      expect((cubit.state as MovieDetailSuccess).isStale, isTrue);
    });

    test('ignores stale stream events after newer movieId request', () async {
      final firstController = StreamController<MovieDetail?>.broadcast();
      final secondController = StreamController<MovieDetail?>.broadcast();

      final cubit = _cubit(
        _FakeMovieRepository(
          watchDetail: (movieId) {
            if (movieId == 550) return firstController.stream;
            if (movieId == 807) return secondController.stream;
            return Stream.value(null);
          },
          refreshDetail: (_) async => const Success(null),
        ),
      );
      addTearDown(cubit.close);
      addTearDown(firstController.close);
      addTearDown(secondController.close);

      await cubit.load(550);
      firstController.add(_detail);
      await Future<void>.delayed(Duration.zero);

      const se7en = MovieDetail(
        id: 807,
        title: 'Se7en',
        voteAverage: 8.3,
        revenue: 327311859,
        status: 'Released',
      );

      await cubit.load(807);
      secondController.add(se7en);
      await Future<void>.delayed(Duration.zero);

      firstController.add(_detail);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, isA<MovieDetailSuccess>());
      expect((cubit.state as MovieDetailSuccess).detail.id, 807);
    });

    test('refresh failure without cache emits failure', () async {
      final cubit = _cubit(
        _FakeMovieRepository(
          watchDetail: (_) => Stream.value(null),
          refreshDetail: (_) async =>
              const Error<void>(ServerFailure('Network down')),
        ),
      );
      addTearDown(cubit.close);

      await cubit.load(550);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, isA<MovieDetailFailure>());
      expect((cubit.state as MovieDetailFailure).movieId, 550);
    });
  });
}

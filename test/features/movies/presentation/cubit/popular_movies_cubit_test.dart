import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tutotial_for_learn/core/errors/failures.dart';
import 'package:flutter_tutotial_for_learn/core/utils/result.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/entities/movie.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/usecases/refresh_popular_movies.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/usecases/watch_popular_movies.dart';
import 'package:flutter_tutotial_for_learn/features/movies/presentation/cubit/popular_movies_cubit.dart';
import 'package:flutter_tutotial_for_learn/features/movies/presentation/cubit/popular_movies_state.dart';

import '../../helpers/stub_movie_repository.dart';

const _cachedMovie = Movie(
  id: 550,
  title: 'Fight Club',
  voteAverage: 8.4,
);

class _FakeMovieRepository extends StubMovieRepository {
  _FakeMovieRepository({
    required this.watchPopular,
    required this.refreshPopular,
  });

  final Stream<List<Movie>> Function() watchPopular;
  final Future<Result<void>> Function() refreshPopular;

  @override
  Stream<List<Movie>> watchPopularMovies() => watchPopular();

  @override
  Future<Result<void>> refreshPopularMovies() => refreshPopular();
}

PopularMoviesCubit _cubit(_FakeMovieRepository repository) {
  return PopularMoviesCubit(
    WatchPopularMovies(repository),
    RefreshPopularMovies(repository),
  );
}

void main() {
  group('PopularMoviesCubit — cache-first', () {
    test('shows cached movies without loading flash', () async {
      final cubit = _cubit(
        _FakeMovieRepository(
          watchPopular: () => Stream.value([_cachedMovie]),
          refreshPopular: () async => const Success(null),
        ),
      );
      addTearDown(cubit.close);

      final states = <PopularMoviesState>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.load();
      await Future<void>.delayed(Duration.zero);

      expect(states.any((state) => state is PopularMoviesLoading), isFalse);
      expect(cubit.state, isA<PopularMoviesSuccess>());
      final success = cubit.state as PopularMoviesSuccess;
      expect(success.movies.single.title, 'Fight Club');
      expect(success.isStale, isFalse);

      await sub.cancel();
    });

    test('cold cache emits loading then success after refresh updates stream',
        () async {
      final controller = StreamController<List<Movie>>.broadcast();

      final cubit = _cubit(
        _FakeMovieRepository(
          watchPopular: () => controller.stream,
          refreshPopular: () async {
            controller.add([_cachedMovie]);
            return const Success(null);
          },
        ),
      );
      addTearDown(cubit.close);
      addTearDown(controller.close);

      await cubit.load();
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, isA<PopularMoviesSuccess>());
    });

    test('refresh failure with cache marks state as stale', () async {
      final cubit = _cubit(
        _FakeMovieRepository(
          watchPopular: () => Stream.value([_cachedMovie]),
          refreshPopular: () async =>
              const Error<void>(NetworkFailure('offline')),
        ),
      );
      addTearDown(cubit.close);

      await cubit.load();
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, isA<PopularMoviesSuccess>());
      expect((cubit.state as PopularMoviesSuccess).isStale, isTrue);
    });

    test('refresh failure without cache emits failure', () async {
      final cubit = _cubit(
        _FakeMovieRepository(
          watchPopular: () => Stream.value(const []),
          refreshPopular: () async =>
              const Error<void>(NetworkFailure('offline')),
        ),
      );
      addTearDown(cubit.close);

      await cubit.load();
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, isA<PopularMoviesFailure>());
    });
  });
}

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tutotial_for_learn/core/errors/failures.dart';
import 'package:flutter_tutotial_for_learn/core/utils/result.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/entities/movie.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/usecases/refresh_top_rated_movies.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/usecases/watch_top_rated_movies.dart';
import 'package:flutter_tutotial_for_learn/features/movies/presentation/cubit/top_rated_movies_cubit.dart';
import 'package:flutter_tutotial_for_learn/features/movies/presentation/cubit/top_rated_movies_state.dart';

import '../../helpers/stub_movie_repository.dart';

const _cachedMovie = Movie(
  id: 238,
  title: 'The Godfather',
  voteAverage: 8.7,
);

class _FakeMovieRepository extends StubMovieRepository {
  _FakeMovieRepository({
    required this.watchTopRated,
    required this.refreshTopRated,
  });

  final Stream<List<Movie>> Function() watchTopRated;
  final Future<Result<void>> Function() refreshTopRated;

  @override
  Stream<List<Movie>> watchTopRatedMovies() => watchTopRated();

  @override
  Future<Result<void>> refreshTopRatedMovies() => refreshTopRated();
}

TopRatedMoviesCubit _cubit(_FakeMovieRepository repository) {
  return TopRatedMoviesCubit(
    WatchTopRatedMovies(repository),
    RefreshTopRatedMovies(repository),
  );
}

void main() {
  group('TopRatedMoviesCubit — cache-first', () {
    test('shows cached movies without loading flash', () async {
      final cubit = _cubit(
        _FakeMovieRepository(
          watchTopRated: () => Stream.value([_cachedMovie]),
          refreshTopRated: () async => const Success(null),
        ),
      );
      addTearDown(cubit.close);

      final states = <TopRatedMoviesState>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.load();
      await Future<void>.delayed(Duration.zero);

      expect(states.any((state) => state is TopRatedMoviesLoading), isFalse);
      expect(cubit.state, isA<TopRatedMoviesSuccess>());

      await sub.cancel();
    });

    test('refresh failure with cache marks state as stale', () async {
      final cubit = _cubit(
        _FakeMovieRepository(
          watchTopRated: () => Stream.value([_cachedMovie]),
          refreshTopRated: () async =>
              const Error<void>(NetworkFailure('offline')),
        ),
      );
      addTearDown(cubit.close);

      await cubit.load();
      await Future<void>.delayed(Duration.zero);

      expect((cubit.state as TopRatedMoviesSuccess).isStale, isTrue);
    });
  });
}

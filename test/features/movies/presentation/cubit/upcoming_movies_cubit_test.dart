import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tutotial_for_learn/core/errors/failures.dart';
import 'package:flutter_tutotial_for_learn/core/utils/result.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/entities/movie.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/usecases/refresh_upcoming_movies.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/usecases/watch_upcoming_movies.dart';
import 'package:flutter_tutotial_for_learn/features/movies/presentation/cubit/upcoming_movies_cubit.dart';
import 'package:flutter_tutotial_for_learn/features/movies/presentation/cubit/upcoming_movies_state.dart';

import '../../helpers/stub_movie_repository.dart';

const _cachedMovie = Movie(
  id: 299536,
  title: 'Avengers: Infinity War',
  voteAverage: 8.2,
);

class _FakeMovieRepository extends StubMovieRepository {
  _FakeMovieRepository({
    required this.watchUpcoming,
    required this.refreshUpcoming,
  });

  final Stream<List<Movie>> Function() watchUpcoming;
  final Future<Result<void>> Function() refreshUpcoming;

  @override
  Stream<List<Movie>> watchUpcomingMovies() => watchUpcoming();

  @override
  Future<Result<void>> refreshUpcomingMovies() => refreshUpcoming();
}

UpcomingMoviesCubit _cubit(_FakeMovieRepository repository) {
  return UpcomingMoviesCubit(
    WatchUpcomingMovies(repository),
    RefreshUpcomingMovies(repository),
  );
}

void main() {
  group('UpcomingMoviesCubit — cache-first', () {
    test('shows cached movies without loading flash', () async {
      final cubit = _cubit(
        _FakeMovieRepository(
          watchUpcoming: () => Stream.value([_cachedMovie]),
          refreshUpcoming: () async => const Success(null),
        ),
      );
      addTearDown(cubit.close);

      final states = <UpcomingMoviesState>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.load();
      await Future<void>.delayed(Duration.zero);

      expect(states.any((state) => state is UpcomingMoviesLoading), isFalse);
      expect(cubit.state, isA<UpcomingMoviesSuccess>());

      await sub.cancel();
    });

    test('refresh failure without cache emits failure', () async {
      final cubit = _cubit(
        _FakeMovieRepository(
          watchUpcoming: () => Stream.value(const []),
          refreshUpcoming: () async =>
              const Error<void>(NetworkFailure('offline')),
        ),
      );
      addTearDown(cubit.close);

      await cubit.load();
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, isA<UpcomingMoviesFailure>());
    });
  });
}

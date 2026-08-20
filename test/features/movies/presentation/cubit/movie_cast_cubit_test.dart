import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tutotial_for_learn/core/errors/failures.dart';
import 'package:flutter_tutotial_for_learn/core/utils/result.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/entities/cast_member.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/usecases/refresh_movie_cast.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/usecases/watch_movie_cast.dart';
import 'package:flutter_tutotial_for_learn/features/movies/presentation/cubit/movie_cast_cubit.dart';
import 'package:flutter_tutotial_for_learn/features/movies/presentation/cubit/movie_cast_state.dart';

import '../../helpers/stub_movie_repository.dart';

const _cast = [
  CastMember(
    id: 1,
    name: 'Brad Pitt',
    character: 'Tyler Durden',
    profilePath: '/profile.jpg',
  ),
];

class _FakeMovieRepository extends StubMovieRepository {
  _FakeMovieRepository({
    required this.watchCast,
    required this.refreshCast,
  });

  final Stream<List<CastMember>> Function(int movieId) watchCast;
  final Future<Result<void>> Function(int movieId) refreshCast;

  @override
  Stream<List<CastMember>> watchMovieCast(int movieId) => watchCast(movieId);

  @override
  Future<Result<void>> refreshMovieCast(int movieId) => refreshCast(movieId);
}

MovieCastCubit _cubit(_FakeMovieRepository repository) {
  return MovieCastCubit(
    WatchMovieCast(repository),
    RefreshMovieCast(repository),
  );
}

void main() {
  group('MovieCastCubit — cache-first', () {
    test('emits success with cached cast list', () async {
      final cubit = _cubit(
        _FakeMovieRepository(
          watchCast: (_) => Stream.value(_cast),
          refreshCast: (_) async => const Success(null),
        ),
      );
      addTearDown(cubit.close);

      await cubit.load(550);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, isA<MovieCastSuccess>());
      expect((cubit.state as MovieCastSuccess).cast, _cast);
    });

    test('emits failure independently when refresh fails without cache',
        () async {
      final cubit = _cubit(
        _FakeMovieRepository(
          watchCast: (_) => Stream.value(const []),
          refreshCast: (_) async =>
              const Error<void>(ServerFailure('Cast unavailable')),
        ),
      );
      addTearDown(cubit.close);

      await cubit.load(550);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, isA<MovieCastFailure>());
      expect((cubit.state as MovieCastFailure).message, 'Cast unavailable');
    });
  });
}

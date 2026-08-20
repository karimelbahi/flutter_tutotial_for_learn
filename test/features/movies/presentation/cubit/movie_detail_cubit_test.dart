import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tutotial_for_learn/core/errors/failures.dart';
import 'package:flutter_tutotial_for_learn/core/utils/result.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/entities/movie_detail.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/usecases/get_movie_detail.dart';
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
  _FakeMovieRepository({required this.onGetMovieDetail});

  final Future<Result<MovieDetail>> Function(int movieId) onGetMovieDetail;

  @override
  Future<Result<MovieDetail>> getMovieDetail(int movieId) =>
      onGetMovieDetail(movieId);
}

MovieDetailCubit _cubit(
  Future<Result<MovieDetail>> Function(int movieId) handler,
) {
  return MovieDetailCubit(
    GetMovieDetail(_FakeMovieRepository(onGetMovieDetail: handler)),
  );
}

void main() {
  group('MovieDetailCubit', () {
    test('emits success with detail', () async {
      final cubit = _cubit((_) async => Success(_detail));
      addTearDown(cubit.close);

      await cubit.load(550);

      expect(cubit.state, isA<MovieDetailSuccess>());
      expect((cubit.state as MovieDetailSuccess).detail, _detail);
    });

    test('emits failure on error', () async {
      final cubit = _cubit(
        (_) async => const Error(ServerFailure('Network down')),
      );
      addTearDown(cubit.close);

      await cubit.load(550);

      expect(cubit.state, isA<MovieDetailFailure>());
      final state = cubit.state as MovieDetailFailure;
      expect(state.movieId, 550);
      expect(state.message, 'Network down');
    });
  });
}

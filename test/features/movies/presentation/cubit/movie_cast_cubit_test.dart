import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tutotial_for_learn/core/errors/failures.dart';
import 'package:flutter_tutotial_for_learn/core/utils/result.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/entities/cast_member.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/entities/movie.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/entities/movie_detail.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/repositories/movie_repository.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/usecases/get_movie_cast.dart';
import 'package:flutter_tutotial_for_learn/features/movies/presentation/cubit/movie_cast_cubit.dart';
import 'package:flutter_tutotial_for_learn/features/movies/presentation/cubit/movie_cast_state.dart';

const _cast = [
  CastMember(
    id: 1,
    name: 'Brad Pitt',
    character: 'Tyler Durden',
    profilePath: '/profile.jpg',
  ),
];

class _FakeMovieRepository implements MovieRepository {
  _FakeMovieRepository({required this.onGetMovieCast});

  final Future<Result<List<CastMember>>> Function(int movieId) onGetMovieCast;

  @override
  Future<Result<List<CastMember>>> getMovieCast(int movieId) =>
      onGetMovieCast(movieId);

  @override
  Future<Result<MovieDetail>> getMovieDetail(int movieId) =>
      throw UnimplementedError();

  @override
  Future<Result<List<Movie>>> getSimilarMovies(int movieId) =>
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

MovieCastCubit _cubit(
  Future<Result<List<CastMember>>> Function(int movieId) handler,
) {
  return MovieCastCubit(
    GetMovieCast(_FakeMovieRepository(onGetMovieCast: handler)),
  );
}

void main() {
  group('MovieCastCubit', () {
    test('emits success with cast list', () async {
      final cubit = _cubit((_) async => Success(_cast));
      addTearDown(cubit.close);

      await cubit.load(550);

      expect(cubit.state, isA<MovieCastSuccess>());
      expect((cubit.state as MovieCastSuccess).cast, _cast);
    });

    test('emits failure independently of detail', () async {
      final cubit = _cubit(
        (_) async => const Error(ServerFailure('Cast unavailable')),
      );
      addTearDown(cubit.close);

      await cubit.load(550);

      expect(cubit.state, isA<MovieCastFailure>());
      expect((cubit.state as MovieCastFailure).message, 'Cast unavailable');
    });
  });
}

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tutotial_for_learn/core/utils/result.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/entities/movie.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/usecases/refresh_genre_movies.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/usecases/watch_genre_movies.dart';
import 'package:flutter_tutotial_for_learn/features/movies/presentation/cubit/genre_movies_cubit.dart';
import 'package:flutter_tutotial_for_learn/features/movies/presentation/cubit/genre_movies_state.dart';

import '../../helpers/hive_like_watch_stream.dart';
import '../../helpers/stub_movie_repository.dart';

const _actionGenreId = 28;
const _comedyGenreId = 35;

const _actionMovie = Movie(
  id: 1,
  title: 'Action Hit',
  voteAverage: 7.5,
);

const _comedyMovie = Movie(
  id: 2,
  title: 'Comedy Hit',
  voteAverage: 7.0,
);

class _FakeMovieRepository extends StubMovieRepository {
  _FakeMovieRepository({
    required this.watchByGenre,
    required this.refreshByGenre,
  });

  final Stream<List<Movie>> Function(int genreId) watchByGenre;
  final Future<Result<void>> Function(int genreId) refreshByGenre;

  @override
  Stream<List<Movie>> watchMoviesByGenre(int genreId) => watchByGenre(genreId);

  @override
  Future<Result<void>> refreshMoviesByGenre(int genreId) =>
      refreshByGenre(genreId);
}

GenreMoviesCubit _cubit(_FakeMovieRepository repository, {int? initialGenreId}) {
  return GenreMoviesCubit(
    WatchGenreMovies(repository),
    RefreshGenreMovies(repository),
    initialGenreId: initialGenreId ?? _actionGenreId,
  );
}

void main() {
  group('GenreMoviesCubit — cache-first', () {
    test('loads cached movies for selected genre tab', () async {
      final cubit = _cubit(
        _FakeMovieRepository(
          watchByGenre: (genreId) => Stream.value(
            genreId == _actionGenreId ? [_actionMovie] : const [],
          ),
          refreshByGenre: (_) async => const Success(null),
        ),
      );
      addTearDown(cubit.close);

      await cubit.load(_actionGenreId);
      await Future<void>.delayed(Duration.zero);

      final state = cubit.state as GenreMoviesSuccess;
      expect(state.genreId, _actionGenreId);
      expect(state.movies.single.title, 'Action Hit');
    });

    test('ignores stale stream events after tab switch', () async {
      final actionController = StreamController<List<Movie>>.broadcast();
      final comedyController = StreamController<List<Movie>>.broadcast();

      final cubit = _cubit(
        _FakeMovieRepository(
          watchByGenre: (genreId) {
            if (genreId == _actionGenreId) {
              return hiveLikeWatchStream(
                const <Movie>[],
                actionController.stream,
              );
            }
            if (genreId == _comedyGenreId) {
              return hiveLikeWatchStream(
                const <Movie>[],
                comedyController.stream,
              );
            }
            return Stream.value(const []);
          },
          refreshByGenre: (_) async => const Success(null),
        ),
      );
      addTearDown(cubit.close);
      addTearDown(actionController.close);
      addTearDown(comedyController.close);

      await cubit.load(_actionGenreId);
      actionController.add([_actionMovie]);
      await Future<void>.delayed(Duration.zero);

      await cubit.load(_comedyGenreId);
      comedyController.add([_comedyMovie]);
      await Future<void>.delayed(Duration.zero);

      // Late event for old tab must not overwrite comedy selection.
      actionController.add([_actionMovie]);
      await Future<void>.delayed(Duration.zero);

      final state = cubit.state as GenreMoviesSuccess;
      expect(state.genreId, _comedyGenreId);
      expect(state.movies.single.title, 'Comedy Hit');
    });
  });
}

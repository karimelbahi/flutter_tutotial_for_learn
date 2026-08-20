import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tutotial_for_learn/core/errors/failures.dart';
import 'package:flutter_tutotial_for_learn/core/utils/debouncer.dart';
import 'package:flutter_tutotial_for_learn/core/utils/result.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/entities/movie.dart';
import 'package:flutter_tutotial_for_learn/features/movies/domain/usecases/search_movies.dart';
import 'package:flutter_tutotial_for_learn/features/movies/presentation/cubit/search_movies_cubit.dart';
import 'package:flutter_tutotial_for_learn/features/movies/presentation/cubit/search_movies_state.dart';

import '../../helpers/stub_movie_repository.dart';

const _batman = Movie(
  id: 268,
  title: 'Batman',
  voteAverage: 7.2,
  posterPath: '/poster.jpg',
  releaseDate: '1989-06-23',
);

class _FakeMovieRepository extends StubMovieRepository {
  _FakeMovieRepository({required this.onSearch});

  final Future<Result<List<Movie>>> Function(String query) onSearch;

  @override
  Future<Result<List<Movie>>> searchMovies(String query) => onSearch(query);
}

SearchMoviesCubit _cubit(Future<Result<List<Movie>>> Function(String) handler) {
  return SearchMoviesCubit(SearchMovies(_FakeMovieRepository(onSearch: handler)));
}

void main() {
  group('Debouncer', () {
    test('runs action after delay', () async {
      final debouncer = Debouncer(milliseconds: 50);
      var ran = false;

      debouncer.run(() => ran = true);
      expect(ran, isFalse);

      await Future<void>.delayed(const Duration(milliseconds: 60));
      expect(ran, isTrue);
    });

    test('cancel prevents pending action', () async {
      final debouncer = Debouncer(milliseconds: 50);
      var ran = false;

      debouncer.run(() => ran = true);
      debouncer.cancel();

      await Future<void>.delayed(const Duration(milliseconds: 60));
      expect(ran, isFalse);
    });
  });

  group('SearchMoviesCubit', () {
    test('empty query resets to initial', () async {
      final cubit = _cubit((_) async => Success([_batman]));
      addTearDown(cubit.close);

      await cubit.search('   ');
      expect(cubit.state, isA<SearchMoviesInitial>());
    });

    test('emits success with movies', () async {
      final cubit = _cubit((_) async => Success([_batman]));
      addTearDown(cubit.close);

      await cubit.search('Batman');

      expect(cubit.state, isA<SearchMoviesSuccess>());
      final state = cubit.state as SearchMoviesSuccess;
      expect(state.query, 'Batman');
      expect(state.movies, [_batman]);
    });

    test('emits empty when no results', () async {
      final cubit = _cubit((_) async => const Success([]));
      addTearDown(cubit.close);

      await cubit.search('zzznomatch123');

      expect(cubit.state, isA<SearchMoviesEmpty>());
      expect((cubit.state as SearchMoviesEmpty).query, 'zzznomatch123');
    });

    test('emits failure on error', () async {
      final cubit = _cubit(
        (_) async => const Error(ServerFailure('Network down')),
      );
      addTearDown(cubit.close);

      await cubit.search('Batman');

      expect(cubit.state, isA<SearchMoviesFailure>());
      final state = cubit.state as SearchMoviesFailure;
      expect(state.query, 'Batman');
      expect(state.message, 'Network down');
    });

    test('reset returns to initial', () async {
      final cubit = _cubit((_) async => Success([_batman]));
      addTearDown(cubit.close);

      await cubit.search('Batman');
      cubit.reset();

      expect(cubit.state, isA<SearchMoviesInitial>());
    });

    test('ignores stale in-flight response after newer query', () async {
      final slowCompleter = Completer<Result<List<Movie>>>();
      final cubit = _cubit((query) async {
        if (query == 'slow') {
          return slowCompleter.future;
        }
        return Success([_batman]);
      });
      addTearDown(cubit.close);

      unawaited(cubit.search('slow'));
      expect(cubit.state, isA<SearchMoviesLoading>());

      await cubit.search('Batman');
      expect(cubit.state, isA<SearchMoviesSuccess>());

      slowCompleter.complete(Success([_batman]));
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, isA<SearchMoviesSuccess>());
      expect((cubit.state as SearchMoviesSuccess).query, 'Batman');
    });

    test('ignores stale response after clear', () async {
      final slowCompleter = Completer<Result<List<Movie>>>();
      final cubit = _cubit((_) => slowCompleter.future);
      addTearDown(cubit.close);

      unawaited(cubit.search('Batman'));
      cubit.reset();

      slowCompleter.complete(Success([_batman]));
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, isA<SearchMoviesInitial>());
    });
  });
}

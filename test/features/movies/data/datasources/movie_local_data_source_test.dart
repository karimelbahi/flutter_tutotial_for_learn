import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_tutotial_for_learn/core/storage/cache_keys.dart';
import 'package:flutter_tutotial_for_learn/core/storage/hive_service.dart';
import 'package:flutter_tutotial_for_learn/features/movies/data/datasources/movie_local_data_source.dart';
import 'package:flutter_tutotial_for_learn/features/movies/data/models/movie_credits_model.dart';
import 'package:flutter_tutotial_for_learn/features/movies/data/models/movie_detail_model.dart';
import 'package:flutter_tutotial_for_learn/features/movies/data/models/movie_model.dart';

void main() {
  late MovieLocalDataSource local;

  setUp(() async {
    await HiveService.instance.initForTest();
    local = MovieLocalDataSourceImpl();
  });

  tearDown(() async {
    await HiveService.instance.closeForTest();
  });

  group('MovieLocalDataSource — home lists', () {
    test('watchPopularMovies emits empty list when cache is cold', () async {
      final first = await local.watchPopularMovies().first;
      expect(first, isEmpty);
    });

    test('savePopularMovies persists and watch re-emits', () async {
      const movies = [
        MovieModel(id: 550, title: 'Fight Club', voteAverage: 8.4),
      ];

      // take(2): first emit = current cache (empty), second = after Hive put().
      final valuesFuture = local.watchPopularMovies().take(2).toList();

      // Give the stream listener time to attach before we write.
      await Future<void>.delayed(const Duration(milliseconds: 10));
      await local.savePopularMovies(movies);

      final values = await valuesFuture;
      expect(values, hasLength(2));
      expect(values.first, isEmpty);
      expect(values.last.single.title, 'Fight Club');
    });

    test('getMetadata returns timestamp after save', () async {
      await local.saveTopRatedMovies(const [
        MovieModel(id: 1, title: 'A', voteAverage: 7),
      ]);

      final metadata = local.getMetadata(CacheKeys.topRated);
      expect(metadata, isNotNull);
      expect(metadata!.fetchedAt.isBefore(DateTime.now().add(const Duration(seconds: 1))), isTrue);
    });
  });

  group('MovieLocalDataSource — detail sections', () {
    test('save and watch movie detail by id', () async {
      const detail = MovieDetailModel(
        id: 272,
        title: 'Batman Begins',
        voteAverage: 7.7,
        revenue: 374000000,
        status: 'Released',
      );

      await local.saveMovieDetail(272, detail);

      final cached = await local.watchMovieDetail(272).first;
      expect(cached?.title, 'Batman Begins');
    });

    test('save and watch cast list', () async {
      const cast = [
        CastMemberModel(
          id: 1,
          name: 'Actor',
          character: 'Hero',
        ),
      ];

      await local.saveMovieCast(99, cast);

      final cached = await local.watchMovieCast(99).first;
      expect(cached, hasLength(1));
      expect(cached.first.name, 'Actor');
    });

    test('save and watch similar movies in dedicated box', () async {
      await local.saveSimilarMovies(10, const [
        MovieModel(id: 20, title: 'Similar', voteAverage: 6),
      ]);

      final cached = await local.watchSimilarMovies(10).first;
      expect(cached.single.id, 20);
    });
  });
}

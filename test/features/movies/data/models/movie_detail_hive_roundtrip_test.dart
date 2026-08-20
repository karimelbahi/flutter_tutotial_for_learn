import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tutotial_for_learn/core/storage/hive_service.dart';
import 'package:flutter_tutotial_for_learn/features/movies/data/datasources/movie_local_data_source.dart';
import 'package:flutter_tutotial_for_learn/features/movies/data/models/movie_detail_model.dart';

void main() {
  late MovieLocalDataSource local;

  setUp(() async {
    await HiveService.instance.initForTest();
    local = MovieLocalDataSourceImpl();
  });

  tearDown(() async {
    await HiveService.instance.closeForTest();
  });

  test('movie detail survives Hive round-trip with genres and backdrops', () async {
    final fromApi = MovieDetailModel.fromJson({
      'id': 550,
      'title': 'Fight Club',
      'overview': 'A ticking-time-bomb insomniac...',
      'poster_path': '/poster.jpg',
      'release_date': '1999-10-15',
      'runtime': 139,
      'vote_average': 8.433,
      'revenue': 100853753,
      'status': 'Released',
      'homepage': 'http://www.foxmovies.com/movies/fight-club',
      'genres': [
        {'id': 18, 'name': 'Drama'},
        {'id': 53, 'name': 'Thriller'},
      ],
      'images': {
        'backdrops': [
          {'file_path': '/abc.jpg', 'width': 1280},
          {'file_path': '/def.jpg', 'width': 1280},
        ],
      },
    });

    await local.saveMovieDetail(550, fromApi);

    final cached = await local.watchMovieDetail(550).first;
    expect(cached, isNotNull);
    expect(cached!.title, 'Fight Club');
    expect(cached.genres, hasLength(2));
    expect(cached.genres.first.name, 'Drama');
    expect(cached.backdropPaths, hasLength(2));
  });
}

import '../../domain/entities/movie_detail.dart';

/// Parses TMDB movie detail JSON (with `append_to_response=images`).
class MovieDetailModel {
  const MovieDetailModel({
    required this.id,
    required this.title,
    required this.voteAverage,
    required this.revenue,
    required this.status,
    this.overview,
    this.posterPath,
    this.releaseDate,
    this.runtime,
    this.homepage,
    this.genres = const [],
    this.backdropPaths = const [],
  });

  final int id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? releaseDate;
  final int? runtime;
  final double voteAverage;
  final int revenue;
  final String status;
  final String? homepage;
  final List<MovieDetailGenre> genres;
  final List<String> backdropPaths;

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    final images = _readMap(json['images']);
    final backdrops = images?['backdrops'] as List<dynamic>? ?? const [];

    return MovieDetailModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      releaseDate: json['release_date'] as String?,
      runtime: (json['runtime'] as num?)?.toInt(),
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      revenue: (json['revenue'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? '',
      homepage: json['homepage'] as String?,
      genres: (json['genres'] as List<dynamic>?)
              ?.map((item) {
                final genre = _readMap(item);
                if (genre == null) return null;
                return MovieDetailGenre(
                  id: (genre['id'] as num?)?.toInt() ?? 0,
                  name: genre['name'] as String? ?? '',
                );
              })
              .whereType<MovieDetailGenre>()
              .toList() ??
          const [],
      backdropPaths: backdrops
          .map((item) => _readMap(item)?['file_path'] as String?)
          .whereType<String>()
          .where((path) => path.isNotEmpty)
          .toList(),
    );
  }

  /// Hive reloads nested JSON as [Map<dynamic, dynamic>] — normalize safely.
  static Map<String, dynamic>? _readMap(Object? value) {
    if (value is! Map) return null;
    return Map<String, dynamic>.from(value);
  }

  /// Round-trip format for Hive — keeps the shape [fromJson] expects.
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'overview': overview,
        'poster_path': posterPath,
        'release_date': releaseDate,
        'runtime': runtime,
        'vote_average': voteAverage,
        'revenue': revenue,
        'status': status,
        'homepage': homepage,
        'genres': genres
            .map((genre) => {'id': genre.id, 'name': genre.name})
            .toList(),
        'images': {
          'backdrops': backdropPaths
              .map((path) => {'file_path': path})
              .toList(),
        },
      };

  MovieDetail toEntity() {
    return MovieDetail(
      id: id,
      title: title,
      overview: overview,
      posterPath: posterPath,
      releaseDate: releaseDate,
      runtime: runtime,
      voteAverage: voteAverage,
      revenue: revenue,
      status: status,
      homepage: homepage,
      genres: genres,
      backdropPaths: backdropPaths,
    );
  }
}

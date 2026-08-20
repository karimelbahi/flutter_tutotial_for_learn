import '../../domain/entities/movie.dart';

/// Data Transfer Object (DTO) — parses raw TMDB JSON.
///
/// **Data layer only.** Knows about JSON field names (`poster_path`, etc.).
/// Converts to domain [Movie] via [toEntity] before leaving the repository.
class MovieModel {
  const MovieModel({
    required this.id,
    required this.title,
    required this.voteAverage,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.overview,
    this.genreIds = const [],
  });

  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String? releaseDate;
  final String? overview;
  final List<int> genreIds;

  /// Parses one item from TMDB `results[]` array.
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: json['release_date'] as String?,
      overview: json['overview'] as String?,
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((id) => id as int)
              .toList() ??
          const [],
    );
  }

  /// Serializes this model for Hive storage.
  ///
  /// We mirror TMDB field names so [fromJson] can decode cached rows later.
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'poster_path': posterPath,
        'backdrop_path': backdropPath,
        'vote_average': voteAverage,
        'release_date': releaseDate,
        'overview': overview,
        'genre_ids': genreIds,
      };

  /// Maps data model → domain entity ( strips JSON concerns ).
  Movie toEntity() {
    return Movie(
      id: id,
      title: title,
      posterPath: posterPath,
      backdropPath: backdropPath,
      voteAverage: voteAverage,
      releaseDate: releaseDate,
      overview: overview,
      genreIds: genreIds,
    );
  }
}

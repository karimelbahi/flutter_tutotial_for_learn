import 'package:equatable/equatable.dart';

/// Genre chip on the movie detail screen (from TMDB detail response).
class MovieDetailGenre extends Equatable {
  const MovieDetailGenre({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

/// Full movie detail — domain entity for the detail screen.
class MovieDetail extends Equatable {
  const MovieDetail({
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

  String? get releaseYear {
    if (releaseDate == null || releaseDate!.length < 4) return null;
    return releaseDate!.substring(0, 4);
  }

  @override
  List<Object?> get props => [
        id,
        title,
        overview,
        posterPath,
        releaseDate,
        runtime,
        voteAverage,
        revenue,
        status,
        homepage,
        genres,
        backdropPaths,
      ];
}

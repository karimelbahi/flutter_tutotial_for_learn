import 'package:equatable/equatable.dart';

/// Domain entity — pure business object with no JSON or Flutter imports.
///
/// Lives in the **domain** layer. The UI and Cubit work with `Movie`,
/// never with `MovieModel` (data layer).
///
/// Compare to reference app: their `MovieList` class mixed JSON parsing
/// with the model. We split that into Movie (domain) + MovieModel (data).
class Movie extends Equatable {
  const Movie({
    required this.id,
    required this.title,
    required this.voteAverage,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.overview,
    this.genreIds = const [],
  });

  /// TMDB unique movie ID — used for navigation to detail screen.
  final int id;

  /// Display title shown on cards and carousel.
  final String title;

  /// Relative path, e.g. `/abc123.jpg` — prepend AppConfig.imageUrl() in UI.
  final String? posterPath;

  /// Wide image for the home carousel banner.
  final String? backdropPath;

  /// TMDB score from 0.0 to 10.0 (reference app divides by 2 for star rating).
  final double voteAverage;

  /// ISO date string from API, e.g. `1999-10-15`.
  final String? releaseDate;

  final String? overview;

  /// Genre IDs attached to this movie in list responses.
  final List<int> genreIds;

  /// Extracts release year for subtitles, e.g. "1999" from "1999-10-15".
  String? get releaseYear {
    if (releaseDate == null || releaseDate!.length < 4) return null;
    return releaseDate!.substring(0, 4);
  }

  @override
  List<Object?> get props => [
        id,
        title,
        posterPath,
        backdropPath,
        voteAverage,
        releaseDate,
        overview,
        genreIds,
      ];
}

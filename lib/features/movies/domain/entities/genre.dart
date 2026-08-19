import 'package:equatable/equatable.dart';

/// A TMDB genre used for home screen tabs.
///
/// These 18 genres are **hardcoded** (same as the reference app) because
/// TMDB genre IDs never change. No API call needed to build the tab bar.
class Genre extends Equatable {
  const Genre({required this.id, required this.name});

  final int id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

/// Static genre list for home screen TabBar — mirrors reference `genre.dart`.
const List<Genre> kMovieGenres = [
  Genre(id: 28, name: 'Action'),
  Genre(id: 12, name: 'Adventure'),
  Genre(id: 16, name: 'Animation'),
  Genre(id: 35, name: 'Comedy'),
  Genre(id: 80, name: 'Crime'),
  Genre(id: 99, name: 'Documentary'),
  Genre(id: 18, name: 'Drama'),
  Genre(id: 10751, name: 'Family'),
  Genre(id: 14, name: 'Fantasy'),
  Genre(id: 27, name: 'Horror'),
  Genre(id: 10402, name: 'Music'),
  Genre(id: 9648, name: 'Mystery'),
  Genre(id: 10749, name: 'Romance'),
  Genre(id: 878, name: 'Science Fiction'),
  Genre(id: 10770, name: 'TV Movie'),
  Genre(id: 53, name: 'Thriller'),
  Genre(id: 10752, name: 'War'),
  Genre(id: 37, name: 'Western'),
];

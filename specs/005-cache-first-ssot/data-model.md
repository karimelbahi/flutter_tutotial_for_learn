# Data Model: Cache-First SSOT

**Feature**: 005-cache-first-ssot | **Date**: 2026-08-20

## Overview

Hive stores **data-layer models** (DTOs), not domain entities. The repository maps models → entities before emitting on watch streams.

## Hive Boxes

### `movies_lists`

| Key | Value | Domain mapping |
|-----|-------|----------------|
| `popular` | `List<Map>` → `List<MovieModel>` | `List<Movie>` |
| `top_rated` | same | `List<Movie>` |
| `upcoming` | same | `List<Movie>` |
| `genre_{genreId}` | same | `List<Movie>` |

**Example key**: `genre_28` (Action)

### `movie_details`

| Key | Value | Domain mapping |
|-----|-------|----------------|
| `{movieId}` (int as string) | `Map` → `MovieDetailModel` | `MovieDetail` |

### `movie_cast`

| Key | Value | Domain mapping |
|-----|-------|----------------|
| `{movieId}` | `List<Map>` → cast models | `List<CastMember>` |

### `similar_movies`

| Key | Value | Domain mapping |
|-----|-------|----------------|
| `{movieId}` | `List<Map>` → `MovieModel` | `List<Movie>` |

### `cache_metadata`

| Key | Value | Purpose |
|-----|-------|---------|
| mirrors data key | `CacheMetadata` | `{ fetchedAt: DateTime }` |

```dart
class CacheMetadata {
  const CacheMetadata({required this.fetchedAt});
  final DateTime fetchedAt;

  bool isExpired(Duration ttl) =>
      DateTime.now().difference(fetchedAt) > ttl;
}
```

## Entity Fields (unchanged domain)

Existing domain entities remain the UI contract:

- `Movie` — id, title, posterPath, backdropPath, voteAverage, releaseDate, overview, genreIds
- `MovieDetail` — extended detail fields (runtime, revenue, genres, etc.)
- `CastMember` — id, name, character, profilePath

## Model JSON Extensions Required

Add `toJson()` to (minimum):

- `MovieModel`
- `MovieDetailModel`
- Cast member model(s) in `movie_credits_model.dart`

## State Extensions (presentation)

Cached cubit success states gain optional flags:

```dart
class PopularMoviesSuccess extends PopularMoviesState {
  const PopularMoviesSuccess(
    this.movies, {
    this.isStale = false,
    this.isRefreshing = false,
  });

  final List<Movie> movies;
  final bool isStale;
  final bool isRefreshing;
}
```

Apply same pattern to: top rated, upcoming, genre, detail, cast, similar.

## Cache Key Helpers

```dart
abstract class CacheKeys {
  static const popular = 'popular';
  static const topRated = 'top_rated';
  static const upcoming = 'upcoming';
  static String genre(int id) => 'genre_$id';
  static String movieDetail(int id) => '$id';
  static String movieCast(int id) => '$id';
  static String similarMovies(int id) => '$id';
}
```

Location: `lib/core/storage/cache_keys.dart` or inside `movie_local_data_source.dart`.

## Relationships

```text
CacheMetadata (1) ── describes ── (1) movies_lists entry per key
movies_lists[key] ── contains ── * MovieModel
movie_details[id] ── 1:1 ── MovieDetailModel
movie_cast[id] ── 1:1 ── List CastMemberModel
similar_movies[id] ── 1:1 ── List MovieModel
```

## Validation Rules

- Empty list from network → still valid cache (clear previous)
- `movieId <= 0` → skip cache read/write
- JSON parse failure → delete key + metadata; log in debug

# Data Model: Movie Home Screen

**Feature**: 001-movie-home | **Date**: 2026-08-20

## Entity: Movie

Represents a movie in list/carousel contexts on the home screen.

| Field | Type | Required | Source (TMDB JSON) | Notes |
|-------|------|----------|-------------------|-------|
| id | int | yes | `id` | Unique TMDB movie ID |
| title | String | yes | `title` | Display name |
| posterPath | String? | no | `poster_path` | Relative path; prepend `AppConfig.imageUrl()` |
| backdropPath | String? | no | `backdrop_path` | Used in carousel |
| voteAverage | double | yes | `vote_average` | 0–10 scale; display as stars /10 |
| releaseDate | String? | no | `release_date` | ISO date string |
| overview | String? | no | `overview` | Not shown on home lists |
| genreIds | List<int>? | no | `genre_ids` | Optional on list responses |

### Validation rules

- `id` must be > 0
- `title` must not be empty when present
- `voteAverage` clamped 0.0–10.0 for display

### UI mapping

- **Carousel**: backdrop + title (top 5 from popular list)
- **Movie card**: poster + title + rating bar (voteAverage / 2 for 5-star display)
- **Upcoming row**: poster + title + release year subtitle

## Entity: Genre

Static catalog for tab labels and filter IDs.

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| id | int | yes | TMDB genre ID |
| name | String | yes | English label (i18n key mapped separately) |

### Static list (18 genres — from reference)

| ID | Name |
|----|------|
| 28 | Action |
| 12 | Adventure |
| 16 | Animation |
| 35 | Comedy |
| 80 | Crime |
| 99 | Documentary |
| 18 | Drama |
| 10751 | Family |
| 14 | Fantasy |
| 27 | Horror |
| 10402 | Music |
| 9648 | Mystery |
| 10749 | Romance |
| 878 | Science Fiction |
| 10770 | TV Movie |
| 53 | Thriller |
| 10752 | War |
| 37 | Western |

## Model: MovieModel (data layer)

JSON deserialization in `data/models/movie_model.dart`:

```dart
factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
  id: json['id'] as int,
  title: json['title'] as String? ?? '',
  posterPath: json['poster_path'] as String?,
  backdropPath: json['backdrop_path'] as String?,
  voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
  releaseDate: json['release_date'] as String?,
  overview: json['overview'] as String?,
  genreIds: (json['genre_ids'] as List<dynamic>?)
      ?.map((e) => e as int)
      .toList(),
);
```

Maps to domain `Movie` entity via `toEntity()`.

## State transitions (per Cubit)

```
Initial → Loading → Success(data)
                 └→ Failure(message) → (retry) → Loading
```

Each section cubit is independent; no shared state between Popular / Genre / TopRated / Upcoming.

## Relationships

```
Genre (1) ──filters──▶ Movie (many)   via TMDB discover?with_genres={id}
Popular API ──▶ Movie (many)          top 5 used for carousel
Top Rated API ──▶ Movie (many)
Upcoming API ──▶ Movie (many)
```

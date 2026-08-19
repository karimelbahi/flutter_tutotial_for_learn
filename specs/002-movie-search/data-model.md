# Data Model: Movie Search Screen

**Feature**: 002-movie-search | **Date**: 2026-08-20

## Entity: Search Query (ephemeral)

Not persisted — lives in `TextEditingController` on the screen and as a parameter to cubit methods.

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| text | String | yes | User input; trimmed before API call |
| debouncedAt | DateTime | no | Implicit via 1s debouncer |

### Validation rules

- Empty or whitespace-only query → no API call; cubit emits `SearchMoviesInitial`
- Non-empty query → debounce → `SearchMoviesCubit.search(query)`

## Entity: Movie (reused from 001)

Search results map to the existing domain `Movie` entity. No new entity required.

| Field | Used in search row | Notes |
|-------|-------------------|-------|
| id | navigation | Tap → detail with `movieId` |
| title | list tile title | Required |
| posterPath | list tile leading image | Null → placeholder |
| releaseDate | list tile subtitle | Show year (first 4 chars) or `common.tba` |

Fields not shown on search row: `backdropPath`, `voteAverage`, `overview`, `genreIds`.

## Model: MovieModel (reused)

Same `MovieModel.fromJson` / `toEntity()` as home lists — TMDB search `results[]` uses identical movie list JSON.

## Cubit state model

```
SearchMoviesInitial
    │  user types (debounced, non-empty)
    ▼
SearchMoviesLoading
    ├─ results.length > 0 ──▶ SearchMoviesSuccess(movies, query)
    ├─ results.isEmpty ─────▶ SearchMoviesEmpty(query)
    └─ error ───────────────▶ SearchMoviesFailure(message, query)

SearchMoviesInitial ◀── reset() / clear button
SearchMoviesLoading ──▶ (stale if query changed) ──▶ discard, keep current state
```

### State fields

| State | Fields | UI |
|-------|--------|-----|
| Initial | — | Empty body |
| Loading | optional `query` | Spinner |
| Success | `movies: List<Movie>`, `query: String` | Result list |
| Empty | `query: String` | "No movies found" message |
| Failure | `message: String`, `query: String` | Error + retry |

## Relationships

```
Search Query (1) ──queries──▶ Movie (many)   via GET /search/movie?query={text}
Movie (1) ──tap──▶ Movie Detail route      movieId argument
```

## Repository extension

Add to abstract `MovieRepository`:

```dart
Future<Result<List<Movie>>> searchMovies(String query);
```

Implemented in `MovieRepositoryImpl` delegating to `MovieRemoteDataSource.fetchSearchMovies(query)`.

# TMDB API Contract: Search Endpoint

**Feature**: 002-movie-search | **Base URL**: `https://api.themoviedb.org/3`

All requests require query param `api_key={API_KEY}` from `.env`.

## Search Movies

**Endpoint**: `GET /search/movie`

**Query params**:

| Param | Value | Required |
|-------|-------|----------|
| `api_key` | from `.env` | yes |
| `query` | URL-encoded search text | yes |
| `page` | `1` | yes |
| `language` | `en-US` | yes |
| `include_adult` | `false` | yes |

**AppConfig**: `AppConfig.searchMoviesUrl(query)` (reference helper; Retrofit uses typed params)

**Retrofit** (target on `TmdbApi`):

```dart
@GET('/search/movie')
Future<TmdbMoviesResponse> searchMovies(
  @Query('api_key') String apiKey,
  @Query('query') String query,
  @Query('page') int page,
  @Query('language') String language,
  @Query('include_adult') bool includeAdult,
);
```

**Response shape** (relevant fields):

```json
{
  "page": 1,
  "total_results": 42,
  "total_pages": 3,
  "results": [
    {
      "id": 550,
      "title": "Fight Club",
      "poster_path": "/path.jpg",
      "backdrop_path": "/backdrop.jpg",
      "vote_average": 8.4,
      "release_date": "1999-10-15",
      "overview": "..."
    }
  ]
}
```

**App usage**: Map all `results[]` to `Movie` list (no pagination in v1).

---

## Image URLs

Same as home contract — `{IMAGE_URL}{poster_path}` via `AppConfig.imageUrl(path)`.

Null `poster_path`: show placeholder in `ListTileSearch` (no network request).

---

## Error handling contract

| HTTP status | App behavior |
|-------------|--------------|
| 200 + empty results | `SearchMoviesEmpty` |
| 200 + results | `SearchMoviesSuccess` |
| 401 | Failure — invalid API key |
| 5xx / timeout | Failure — show message + retry |
| Network offline | Failure — show message + retry |

Debounce: only one in-flight search per debounced query; stale responses discarded if query changed.

---

## Client-side query rules

| Input | Behavior |
|-------|----------|
| Empty / whitespace | No request; `SearchMoviesInitial` |
| Non-empty trimmed text | Debounce 1s → API call |
| Clear tapped | Cancel pending debounce; reset cubit; empty field |

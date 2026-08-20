# Data Model: Movie Detail Screen

**Feature**: 003-movie-detail | **Date**: 2026-08-20

## Entity: MovieDetail

| Field | Type | Required | UI usage |
|-------|------|----------|----------|
| id | int | yes | Navigation, similar tap |
| title | String | yes | Header |
| overview | String? | no | Overview text (max 5 lines) |
| posterPath | String? | no | Poster image |
| releaseDate | String? | no | Year in header |
| runtime | int? | no | Minutes → "2h 15m" |
| voteAverage | double | yes | Stats rating /10 |
| revenue | int | yes | Stats revenue (0 → dash) |
| status | String | yes | Stats status label |
| homepage | String? | no | Visit Website menu |
| genres | List<MovieDetailGenre> | yes | Genre chips |
| backdropPaths | List<String> | yes | Carousel slides |

## Entity: MovieDetailGenre

| Field | Type | Required |
|-------|------|----------|
| id | int | yes |
| name | String | yes |

Distinct from static home `Genre` tabs entity — these come from TMDB detail response.

## Entity: CastMember

| Field | Type | Required | UI usage |
|-------|------|----------|----------|
| id | int | yes | Future person screen (out of scope) |
| name | String | yes | Card title |
| character | String | yes | Card subtitle |
| profilePath | String? | no | Card poster |

## Entity: Movie (reused)

Similar movies API returns standard list JSON → `MovieModel` → `Movie`.

## Cubit states (each cubit)

```
Initial → Loading → Success(data)
                 └→ Failure(message) → retry
```

Detail cubit tracks `_latestMovieId` to ignore stale responses when similar tap reloads screen.

## Relationships

```
movieId ──▶ MovieDetail     via GET /movie/{id}
movieId ──▶ CastMember[]    via GET /movie/{id}/credits
movieId ──▶ Movie[]         via GET /movie/{id}/similar
Similar Movie tap ──▶ new movieId ──▶ reload all three cubits
```

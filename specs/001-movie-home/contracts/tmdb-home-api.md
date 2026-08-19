# TMDB API Contract: Home Screen Endpoints

**Feature**: 001-movie-home | **Base URL**: `https://api.themoviedb.org/3`

All requests require query param `api_key={API_KEY}` from `.env`.

## 1. Popular Movies (carousel source)

**Endpoint**: `GET /movie/popular`

**Query params**: `api_key`, `page=1`, `language=en-US` (optional)

**AppConfig**: `AppConfig.popularMoviesUrl`

**Response shape** (relevant fields):

```json
{
  "results": [
    {
      "id": 550,
      "title": "Fight Club",
      "poster_path": "/path.jpg",
      "backdrop_path": "/backdrop.jpg",
      "vote_average": 8.4,
      "release_date": "1999-10-15",
      "overview": "...",
      "genre_ids": [18, 53]
    }
  ]
}
```

**App usage**: Take first 5 results for carousel.

---

## 2. Discover by Genre

**Endpoint**: `GET /discover/movie`

**Query params**: `api_key`, `with_genres={genreId}`, `sort_by=popularity.desc`,
`include_adult=false`, `page=1`, `language=en-US`

**AppConfig**: `AppConfig.genreMoviesUrl(genreId)`

**Response**: Same `results[]` movie list shape as popular.

---

## 3. Top Rated Movies

**Endpoint**: `GET /movie/top_rated`

**Query params**: `api_key`, `page=1`, `language=en-US`

**AppConfig**: `AppConfig.topRatedMoviesUrl`

---

## 4. Upcoming Movies

**Endpoint**: `GET /movie/upcoming`

**Query params**: `api_key`, `page=1`, `language=en-US`

**AppConfig**: `AppConfig.upcomingMoviesUrl`

---

## Image URLs

**Pattern**: `{IMAGE_URL}{path}`

**Example**: `https://image.tmdb.org/t/p/w500/path.jpg`

**AppConfig**: `AppConfig.imageUrl(posterPath)`

**Null path**: Show placeholder widget (no network request).

---

## Error handling contract

| HTTP status | App behavior |
|-------------|--------------|
| 200 | Parse JSON, emit Success |
| 401 | Failure — invalid API key |
| 404 | Failure — endpoint error |
| 5xx / timeout | Failure — retry button in section |
| Network offline | Failure — retry button |

Errors MUST NOT crash other home sections.

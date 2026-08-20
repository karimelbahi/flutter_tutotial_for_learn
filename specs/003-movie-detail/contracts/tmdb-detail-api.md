# TMDB API Contract: Movie Detail Endpoints

**Feature**: 003-movie-detail | **Base URL**: `https://api.themoviedb.org/3`

## 1. Movie Detail

**Endpoint**: `GET /movie/{movie_id}`

**Query params**: `api_key`, `append_to_response=images`

**AppConfig**: `AppConfig.movieDetailUrl(movieId)`

**Relevant response fields**:

```json
{
  "id": 550,
  "title": "Fight Club",
  "overview": "...",
  "poster_path": "/path.jpg",
  "release_date": "1999-10-15",
  "runtime": 139,
  "vote_average": 8.4,
  "revenue": 100853753,
  "status": "Released",
  "homepage": "http://www.fightclub.com/",
  "genres": [{ "id": 18, "name": "Drama" }],
  "images": {
    "backdrops": [{ "file_path": "/backdrop.jpg" }]
  }
}
```

## 2. Movie Credits

**Endpoint**: `GET /movie/{movie_id}/credits`

**AppConfig**: `AppConfig.movieCreditsUrl(movieId)`

**Relevant fields**:

```json
{
  "cast": [
    {
      "id": 819,
      "name": "Edward Norton",
      "character": "The Narrator",
      "profile_path": "/profile.jpg"
    }
  ]
}
```

## 3. Similar Movies

**Endpoint**: `GET /movie/{movie_id}/similar`

**Query params**: `api_key`, `page=1`

**AppConfig**: `AppConfig.similarMoviesUrl(movieId)`

**Response**: Same `results[]` list shape as home endpoints.

## Error handling

| Status | Behavior |
|--------|----------|
| 200 | Parse → Success |
| 404 | Failure — movie not found |
| 5xx / timeout | Failure + retry per section |

Sections independent — cast failure does not clear detail Success state.

# Implementation Plan: Movie Detail Screen

**Branch**: `003-movie-detail` | **Date**: 2026-08-20 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/003-movie-detail/spec.md`

**Learning constraint (user)**: Implement **section-by-section**, **one commit per deliverable**, study each layer before moving on.

## Summary

Build the TMDB **movie detail screen** under `lib/features/movies/`, matching
`/Users/karimelbahi/Programming/Android/Study/Flutter/flutter-tmdbmovie-bloc-cubit/lib/screens/movie_detail.dart`.

Sections: backdrop carousel → title/meta → poster + genres + overview → stats row → cast row → similar movies.
Three cubits (detail, cast, similar) with independent loading/error states.
Replace `MovieDetailPlaceholderScreen` on the existing detail route.

## Technical Context

**Language/Version**: Dart 3.13+ / Flutter 3.47 (stable)

**Primary Dependencies**: flutter_bloc, equatable, retrofit, dio, carousel_slider, intl, url_launcher, easy_localization

**Storage**: TMDB remote API only

**Testing**: Cubit unit tests + manual quickstart validation

**Target Platform**: iOS + Android (portrait)

**Constraints**: Cubit-only; Retrofit; en/ar i18n; design tokens; reuse `CarouselItem`, `MovieCard`, `SectionHeader`

**Scale/Scope**: 1 screen, 3 cubits, 3 use cases, 3 Retrofit endpoints, ~7 UI commits

## Constitution Check

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Clean Architecture | ✅ PASS | Extend `movies` feature layers |
| II. Cubit-only | ✅ PASS | `MovieDetailCubit`, `MovieCastCubit`, `SimilarMoviesCubit` |
| III. Localization | ✅ PASS | Detail labels, stats, section headers in en/ar |
| IV. Reference-driven UI | ✅ PASS | Port layout from reference detail screen |
| V. Security & Simplicity | ✅ PASS | Retrofit + DioFactory; url_launcher for homepage only |

**Post-design re-check**: ✅ Reuse list `Movie` entity for similar movies; separate `MovieDetail` + `CastMember` entities.

## Delivery Strategy — Commit-by-Commit

| Step | Commit message | Deliverable |
|------|----------------|-------------|
| **1** | `feat(movies): add movie detail domain and data layer` | Entities, models, Retrofit endpoints, repository, use cases |
| **2** | `feat(movies): add movie detail cubits` | 3 cubits + states + presentation module factories |
| **3** | `feat(movies): add movie detail screen shell and backdrop` | Screen shell, carousel, loading/error, replace placeholder route |
| **4** | `feat(movies): add movie detail info and overview section` | Title, year, runtime, poster, genres, overview |
| **5** | `feat(movies): add movie detail stats section` | Rating / revenue / status row |
| **6** | `feat(movies): add movie cast section` | Cast horizontal list |
| **7** | `feat(movies): add similar movies section` | Similar row + tap → new detail |

## Project Structure

```text
lib/features/movies/
├── domain/entities/
│   ├── movie_detail.dart
│   └── cast_member.dart
├── domain/usecases/
│   ├── get_movie_detail.dart
│   ├── get_movie_cast.dart
│   └── get_similar_movies.dart
├── data/models/
│   ├── movie_detail_model.dart
│   └── movie_credits_model.dart
├── data/api/tmdb_api.dart          # + detail, credits, similar
├── presentation/cubit/
│   ├── movie_detail_cubit.dart
│   ├── movie_cast_cubit.dart
│   └── similar_movies_cubit.dart
└── presentation/screens/
    └── movie_detail_screen.dart    # replaces placeholder
```

## Reference File Mapping

| Our file | Reference |
|----------|-----------|
| `movie_detail_screen.dart` | `lib/screens/movie_detail.dart` |
| Backdrop carousel | `_featuredImages` + `CarouselItem` |
| Cast row | `_movieCast` + `MovieCard` |
| Similar row | `_similiarMovie` + `MovieCard` |

## Next Command

Run **`/speckit-tasks`**, then implement **step 1 only**.

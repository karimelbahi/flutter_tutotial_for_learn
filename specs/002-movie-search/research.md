# Research: Movie Search Screen

**Feature**: 002-movie-search | **Date**: 2026-08-20

## R1 — Search API endpoint

**Decision**: `GET /search/movie` via Retrofit on existing `TmdbApi`

**Rationale**: TMDB standard search endpoint; `AppConfig.searchMoviesUrl(query)` already defined.
Same `results[]` movie JSON shape as home list endpoints — reuse `MovieModel` / `Movie`.

**Alternatives considered**:
- Raw Dio in repository (reference app pattern) — rejected; violates constitution V
- Separate `SearchRepository` — rejected; same entity and datasource; extend `MovieRepository`

## R2 — Debounce timing

**Decision**: 1000 ms debounce in screen via `Debouncer` utility

**Rationale**: Matches reference `search.dart` (`Debouncer(milliseconds: 1000)`); satisfies FR-003 and SC-002.

**Alternatives considered**:
- 300 ms — rejected for v1; reference parity preferred
- Debounce inside Cubit — rejected; reference keeps it in screen; simpler to study

## R3 — State management

**Decision**: Single `SearchMoviesCubit` with Initial / Loading / Success / Empty / Failure

**Rationale**: Reference uses one cubit; constitution requires Cubit-only. Empty state is explicit
(FR-009) rather than reference's blank container on zero results.

**Alternatives considered**:
- Reuse home section cubits — rejected; unrelated lifecycle
- BLoC with SearchSubmitted event — rejected; constitution II

## R4 — Entity reuse

**Decision**: Reuse domain `Movie` entity; no `SearchResult` type

**Rationale**: Search rows need id, title, posterPath, releaseDate — all on `Movie`.
Avoids duplicate mapping and models.

**Alternatives considered**:
- Reference `MovieList` model — rejected; we already have Clean Architecture entities

## R5 — UI components

**Decision**: Port `SearchFormField` and `ListTileSearch`; adapt to `AppColors`, `AppTypography`, `AppConfig.imageUrl()`

**Rationale**: Reference-driven UI (constitution IV); poster placeholder for null paths.

**Alternatives considered**:
- Reuse `MovieCard` in vertical list — rejected; reference uses distinct list tile layout

## R6 — Navigation target

**Decision**: Tap result → existing `MovieDetailPlaceholderScreen` via `navigateToMovieDetail()`

**Rationale**: Spec assumption; detail is spec 003. Reuse home navigation helper.

**Alternatives considered**:
- Implement detail in same feature — rejected; screen-by-screen learning path

## R7 — i18n keys

**Decision**: Namespace `search.*` in en.json / ar.json

**Rationale**: Constitution III; keys: `hint`, `empty`, `error`, `clear` (tooltip optional).

**Alternatives considered**:
- Hardcoded "Search" like reference — rejected; violates constitution

## R8 — Stale response handling

**Decision**: Cubit stores latest query string; discard API results when query changed or cleared mid-flight

**Rationale**: Edge case in spec — clear while in-flight must not repopulate list.

**Alternatives considered**:
- Cancel Dio token per request — deferred; query guard is sufficient for v1

## R9 — Delivery / commits

**Decision**: Three commits — data layer → widgets → screen + cubit

**Rationale**: Matches `docs/implementation-plan.md` Phase 8 and user one-commit-per-deliverable rule.

**Alternatives considered**:
- Single search commit — rejected per user workflow

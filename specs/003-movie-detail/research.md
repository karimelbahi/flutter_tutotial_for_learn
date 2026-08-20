# Research: Movie Detail Screen

**Feature**: 003-movie-detail | **Date**: 2026-08-20

## R1 — Detail API shape

**Decision**: `GET /movie/{id}?append_to_response=images` via Retrofit; parse into `MovieDetailModel`

**Rationale**: Matches `AppConfig.movieDetailUrl`; backdrops live in `images.backdrops[]`.

**Alternatives**: Separate images endpoint — rejected; extra round trip.

## R2 — Entity split

**Decision**: New `MovieDetail` + `CastMember` entities; reuse `Movie` for similar list

**Rationale**: List `Movie` lacks runtime, revenue, genres[], backdrops; similar API returns list shape.

## R3 — Repository pattern

**Decision**: Extend `MovieRepository` + `MovieRemoteDataSource` (same as search extension)

**Rationale**: Single TMDB feature module; consistent with 002.

## R4 — Three cubits

**Decision**: Independent cubits for detail, cast, similar (reference parity)

**Rationale**: Independent loading (FR-008, SC-003); each loads on screen init with `movieId`.

**Alternatives**: Single DetailCubit — rejected; harder to retry sections independently.

## R5 — Similar navigation

**Decision**: `Navigator.pushReplacementNamed` or push same route with new `movieId` + cubit reload

**Rationale**: Reference pushes new detail route; cubits must reset on `movieId` change.

## R6 — Revenue formatting

**Decision**: `intl` `NumberFormat.compactCurrency` like reference

**Rationale**: Already in pubspec; reference uses compact USD format.

## R7 — Share menu item

**Decision**: Share menu present but no-op in v1 (reference returns null)

**Rationale**: Spec allows stub; avoids platform share setup in learning scope.

## R8 — Cast display limit

**Decision**: Show max 15 cast members in UI (reference behavior)

**Rationale**: Performance + layout; data layer returns full cast list.

## R9 — Commits

**Decision**: Seven commits per plan (data → cubits → UI sections)

**Rationale**: User one-commit-per-deliverable learning rule.

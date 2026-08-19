# Research: Movie Home Screen

**Feature**: 001-movie-home | **Date**: 2026-08-20

## R1 — State management pattern

**Decision**: Cubit per home section (Popular, Genre, TopRated, Upcoming)

**Rationale**: Reference app uses separate cubits per section; aligns with constitution
and allows independent loading/error states (FR-011, FR-012, SC-006). Easier to learn
one cubit at a time.

**Alternatives considered**:
- Single HomeCubit — rejected; harder to debug, violates section independence
- BLoC with events — rejected; constitution mandates Cubit-only

## R2 — Networking

**Decision**: Single `DioClient` singleton in `core/network/`; movie datasources use it

**Rationale**: Constitution requirement; centralizes timeouts, logging, future auth interceptor.

**Alternatives considered**:
- Raw `Dio()` per repository — rejected; matches reference but violates constitution

## R3 — API configuration

**Decision**: Keep existing `AppConfig` + `flutter_dotenv` for TMDB URLs

**Rationale**: Already implemented; URLs match reference endpoints.

**Alternatives considered**:
- `flutter_config` (reference app) — rejected; older, less maintained

## R4 — Localization

**Decision**: Add `easy_localization` with JSON assets for en/ar

**Rationale**: Constitution requirement; section headers ("Top Rated", "Upcoming") and
errors must be translatable.

**Alternatives considered**:
- Hardcoded English first — rejected; violates constitution III

## R5 — UI components

**Decision**: Port 5 widgets from reference; use `carousel_slider` + `flutter_rating_bar`

**Rationale**: Already in pubspec; reference proves layout. Adapt to design tokens.

**Alternatives considered**:
- Build from scratch — rejected; wastes time, reference clone available locally

## R6 — Genre data

**Decision**: Static genre list (18 TMDB genres) in `domain/entities/genre.dart`

**Rationale**: Reference uses hardcoded list; TMDB genre IDs are stable. No API call needed.

**Alternatives considered**:
- Fetch `/genre/movie/list` — deferred; unnecessary for v1

## R7 — Navigation to detail/search

**Decision**: Named routes; detail/search as placeholder screens until specs 002/003

**Rationale**: Home spec requires navigation entry points (FR-008, FR-009) but detail/search
are separate learning units with own commits.

**Alternatives considered**:
- Implement full detail in same feature — rejected; violates screen-by-screen learning goal

## R8 — Delivery / commits

**Decision**: One commit per home section (steps 0–8 in plan.md)

**Rationale**: User explicitly wants to study each slice and push separately.

**Alternatives considered**:
- Single large home commit — rejected per user request

<!--
Sync Impact Report
- Version change: 1.1.0 → 1.2.0
- Modified principles: None
- Added sections: Principle VI — Cache-First Single Source of Truth (SSOT)
- Removed sections: None
- Deferred TODOs: None
- Spec reference: specs/005-cache-first-ssot/
-->

# Flutter Movie App Constitution

## Core Principles

### I. Clean Architecture (Feature-First)

Every feature MUST live under `lib/features/<feature_name>/` with three layers:
`data/`, `domain/`, and `presentation/`. Shared infrastructure MUST stay in
`lib/core/`. Dependencies MUST point inward: Presentation → Domain → Data → Core.
Presentation MUST NOT import data implementations directly. Widgets MUST NOT call
Retrofit, Dio, or HTTP APIs directly.

**Rationale:** Keeps the TMDB movie app testable, scalable, and consistent as
features grow (home, search, detail, genres).

### II. Cubit-Only State Management

State management MUST use `flutter_bloc` with **Cubit only** (no BLoC event
classes unless explicitly requested). Each screen or cohesive flow MUST have its
own Cubit and Equatable states named: `Initial`, `Loading`, `Success`, `Failure`.
Cubits MUST call use cases or domain repositories — never datasources, Retrofit, or Dio.

**Rationale:** Matches the reference app pattern while keeping state logic simple
and learnable.

### III. Localization First (en / ar)

All user-facing strings MUST use `easy_localization` via `.tr()`. Every new key
MUST be added to both `assets/translations/en.json` and
`assets/translations/ar.json`. Hardcoded UI strings in presentation code are
forbidden.

**Rationale:** Bilingual support is a project requirement, not an afterthought.

### IV. Reference-Driven UI

UI layout and design MUST match the reference app
([flutter-tmdbmovie-bloc-cubit](https://github.com/ihsaninh/flutter-tmdbmovie-bloc-cubit)).
Local reference clone:

`/Users/karimelbahi/Programming/Android/Study/Flutter/flutter-tmdbmovie-bloc-cubit`

Colors, spacing, and typography MUST use design tokens in `lib/core/constants/`
(`AppColors`, `AppSpacing`, `AppTypography`). Port widgets from the reference
into `lib/features/<feature>/presentation/widgets/` — adapt to null-safety and
Clean Architecture; do not copy-paste legacy blocs/repositories wholesale.

**Rationale:** Visual parity with the reference saves time while our architecture
stays modern and maintainable.

### V. Security, Secrets & Simplicity

API keys and secrets MUST live in `.env` (gitignored) and be read via `AppConfig`.
`.env` MUST NEVER be committed. Use `flutter_secure_storage` for sensitive tokens,
Hive for structured cache, and `shared_preferences` for simple flags. Networking
MUST use **Retrofit** typed API interfaces in feature `data/api/` layers, backed by
a single **DioFactory** in `core/network/` (Dio is Retrofit's HTTP engine only).
Prefer the smallest correct change; avoid over-engineering and unrelated refactors.

**Rationale:** Prevents credential leaks and keeps the learning-focused codebase
focused.

### VI. Cache-First Single Source of Truth (SSOT)

For UI-bound movie data, the **local Hive cache is the Single Source of Truth**.
The UI MUST read movie data only through repository **watch streams** backed by
Hive; it MUST NOT consume network responses directly.

| Path | Rule |
|------|------|
| Read | UI ← Cubit ← UseCase ← Repository.watch*() ← Hive |
| Write | Network → RemoteDataSource → LocalDataSource → Hive |
| Refresh | Cubits trigger Repository.refresh*(); failures with valid cache MUST keep showing cached data |
| Flicker | Emit cached data before network refresh completes; avoid Loading when cache is non-empty |
| Search | Network-first exception in v1 (no search query cache unless a spec amends this) |

Repositories MUST coordinate remote and local datasources. Cubits MUST subscribe
to watch streams and cancel subscriptions in `close()`. Network errors with
non-empty cache MUST NOT replace success UI with a blank failure state.

**Rationale:** Instant reopen UX, offline resilience, and a single reactive
data path that scales as features grow.

## Technology Stack Requirements

The following stack is mandatory unless this constitution is amended:

| Concern | Library |
|---------|---------|
| State | `flutter_bloc` (Cubit) |
| i18n | `easy_localization` |
| HTTP | `retrofit` + `dio` (via `DioFactory` + feature `TmdbApi`) |
| Local cache | `hive`, `hive_flutter` |
| Secure storage | `flutter_secure_storage` |
| Preferences | `shared_preferences` |
| Equality | `equatable` |
| Env config | `flutter_dotenv` |

TMDB API configuration MUST use `AppConfig` with keys from `.env`:
`API_KEY`, `BASE_URL`, `IMAGE_URL`.

## Development Workflow & Spec Kit

Features MUST be built using Spec-Driven Development when using Spec Kit:

1. `/speckit-constitution` — this document (ground rules)
2. `/speckit-specify` — what to build (no tech stack)
3. `/speckit-plan` — how to build (Flutter stack + architecture)
4. `/speckit-tasks` — ordered task list
5. `/speckit-implement` — execute tasks
6. `/speckit-converge` — verify completeness

Supporting documentation lives in `docs/` (architecture, folder structure,
tech stack, workflow, boilerplate templates, reference repo path). Cursor rules
in `.cursor/rules/` and the `flutter-movie-app` skill supplement this
constitution for day-to-day agent guidance.

Commits MUST use conventional commits (`feat:`, `fix:`, `docs:`, `chore:`).
Only commit when explicitly requested.

## Governance

This constitution supersedes ad-hoc coding decisions for this project. All specs,
plans, and implementations MUST comply with these principles.

**Amendments:** Update `.specify/memory/constitution.md`, bump version per
semantic rules below, and document changes in the Sync Impact Report comment at
the top of the file.

**Compliance:** Before merging feature work, verify layer boundaries, Cubit
usage, localization keys, design tokens, and no committed secrets.

**Runtime guidance:** Use `docs/architecture.md`, `docs/development-workflow.md`,
and `.cursor/skills/flutter-movie-app/SKILL.md` for detailed conventions.

**Version**: 1.2.0 | **Ratified**: 2026-08-20 | **Last Amended**: 2026-08-20

---
name: flutter-movie-app
description: >-
  Build the flutter_tutotial_for_learn TMDB movie app using Clean Architecture
  (feature-first), Cubit-only state management, easy_localization (en/ar), Dio,
  Hive, and project design tokens. Use when implementing features, screens,
  repositories, cubits, localization, networking, or storage in this project.
---

# Flutter Movie App — Clean Architecture Skill

## When to Use

Apply this skill when working on `flutter_tutotial_for_learn` and the user asks to:
- Add a screen, feature, Cubit, repository, or use case
- Set up localization, Dio, Hive, or storage
- Refactor toward `lib/features/` structure
- Match the reference app design ([flutter-tmdbmovie-bloc-cubit](https://github.com/ihsaninh/flutter-tmdbmovie-bloc-cubit))

## Read First

Before coding, skim these project docs (in order):

1. [docs/architecture.md](../../docs/architecture.md) — layers and dependency rules
2. [docs/folder-structure.md](../../docs/folder-structure.md) — where files go
3. [docs/boilerplate-templates.md](../../docs/boilerplate-templates.md) — code templates

## Core Stack (mandatory)

| Concern | Library | Rule |
|---------|---------|------|
| State | `flutter_bloc` | **Cubit only** — no BLoC events unless user requests |
| i18n | `easy_localization` | All UI strings via `.tr()`; update `en.json` + `ar.json` |
| HTTP | `dio` | Use `DioClient` singleton — never `Dio()` in features |
| Cache | `hive` / `hive_flutter` | Via `HiveService` in `core/storage/` |
| Secrets | `flutter_secure_storage` | Tokens only — not in SharedPreferences |
| Prefs | `shared_preferences` | Flags, onboarding, non-sensitive settings |
| Equality | `equatable` | All Cubit states |

## Architecture Rules

```
presentation → domain → (data implements domain contracts)
data → core
presentation → core (theme, routes, utils only)
```

**Never:**
- Import data layer from presentation (use domain abstractions)
- Hardcode user-facing strings in widgets
- Hardcode colors/sizes (use `AppColors`, `AppSpacing`, `AppTypography`)
- Commit `.env` or API keys

## Feature Implementation Workflow

Copy this checklist per feature:

```
- [ ] Create lib/features/<name>/data|domain|presentation/
- [ ] Domain: abstract repository + use case(s)
- [ ] Data: model, remote/local datasource, repository impl
- [ ] Presentation: cubit + states + screen + widgets
- [ ] Add en.json + ar.json keys
- [ ] Register BlocProvider / dependencies in app.dart
- [ ] dart analyze + flutter test
```

## Design Tokens

Dark TMDB-style theme — tokens in `lib/core/constants/`:

- Background: `AppColors.primary` (#1D1D27)
- Cards/menus: `AppColors.martinique` (#2D2D33)
- Poster: 120×180, radius 2 (`AppSpacing`)

## Commit Style

```
feat(movies): add popular movies cubit and remote datasource
docs: update architecture guide
chore: add hive and easy_localization dependencies
```

One logical change per commit. Do not commit unless user asks.

## TMDB Config

Read URLs/keys from `AppConfig` + `.env`:
- `API_KEY`, `BASE_URL`, `IMAGE_URL`
- Image URL: `AppConfig.imageUrl(posterPath)`

## Additional Reference

- Detailed templates: [templates.md](templates.md)
- Tech stack details: [../../docs/tech-stack.md](../../docs/tech-stack.md)

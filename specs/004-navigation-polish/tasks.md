---
description: "Task list for navigation & polish — one commit per deliverable"
---

# Tasks: Navigation & Polish

**Input**: Design documents from `/specs/004-navigation-polish/`

**Learning rule**: One **commit group** at a time → study → commit → push → next.

## Phase 1: Debug Route Guard — Step 1

**Commit**: `chore(movies): gate dev widget preview behind debug flag`

- [x] T001 Guard `AppRoutes.widgetPreview` in `lib/app/app_router.dart` with `kDebugMode`
- [x] T002 Localize home debug FAB tooltip in `movie_home_screen.dart`

---

## Phase 2: Back Navigation — Step 2

**Commit**: `feat(movies): add consistent back navigation on detail screen`

- [x] T003 Add `showLogoLeading` to `lib/features/movies/presentation/widgets/custom_app_bar.dart`
- [x] T004 Use back navigation on `MovieDetailScreen` app bar

---

## Phase 3: Settings — Step 3

**Commit**: `feat(movies): add settings locale switcher`

- [x] T005 Create `lib/features/movies/presentation/widgets/settings_locale_sheet.dart`
- [x] T006 Wire settings action on `MovieHomeScreen` CustomAppBar
- [x] T007 Add settings i18n keys in `en.json` and `ar.json`

---

## Phase 4: i18n Audit — Step 4

**Commit**: `chore(movies): localize remaining hardcoded UI strings`

- [x] T008 Localize invalid movie detail route screen in `app_router.dart`
- [x] T009 Add `common.unexpected_error` and use in cubit failure fallbacks where user-visible

---

## Phase 5: Polish Validation — Step 5

**Commit**: `docs(movies): validate navigation polish against quickstart checklist`

- [x] T010 Run `dart analyze lib/` and `flutter test`
- [x] T011 Create `specs/004-navigation-polish/checklists/implementation-validation.md`
- [x] T012 Mark Phase 10 complete in `docs/implementation-plan.md`

---

## Commit sequence

| Order | Commit message |
|-------|----------------|
| 1 | `chore(movies): gate dev widget preview behind debug flag` |
| 2 | `feat(movies): add consistent back navigation on detail screen` |
| 3 | `feat(movies): add settings locale switcher` |
| 4 | `chore(movies): localize remaining hardcoded UI strings` |
| 5 | `docs(movies): validate navigation polish against quickstart checklist` |

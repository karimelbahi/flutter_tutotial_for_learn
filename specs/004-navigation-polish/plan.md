# Implementation Plan: Navigation & Polish

**Branch**: `004-navigation-polish` | **Date**: 2026-08-20 | **Spec**: [spec.md](./spec.md)

**Learning constraint**: One commit per deliverable → study → commit → push.

## Summary

Close Phase 10 gaps: debug-only widget preview route, detail back navigation via `CustomAppBar` fix, settings locale sheet, i18n audit for router/errors/tooltips, validation checklist.

## Delivery Strategy — Commit-by-Commit

| Step | Commit message | Deliverable |
|------|----------------|-------------|
| **1** | `chore(movies): gate dev widget preview behind debug flag` | `AppRouter` debug guard; FAB tooltip i18n |
| **2** | `feat(movies): add consistent back navigation on detail screen` | `CustomAppBar` optional logo vs back |
| **3** | `feat(movies): add settings locale switcher` | Settings sheet + en/ar keys + home wiring |
| **4** | `chore(movies): localize remaining hardcoded UI strings` | Invalid route screen, common error keys |
| **5** | `docs(movies): validate navigation polish against quickstart checklist` | Checklist + implementation-plan Phase 10 ✅ |

## Project Structure

```text
lib/
├── app/app_router.dart                          # debug route guard
├── core/constants/app_routes.dart
├── features/movies/presentation/
│   ├── widgets/custom_app_bar.dart              # back vs logo leading
│   ├── widgets/settings_locale_sheet.dart       # new
│   └── screens/movie_home_screen.dart           # settings + FAB i18n
assets/translations/en.json, ar.json             # settings + nav keys
specs/004-navigation-polish/checklists/implementation-validation.md
```

## Constitution Check

| Principle | Status |
|-----------|--------|
| Cubit-only | ✅ No new state libs |
| Localization | ✅ All new UI strings in en/ar |
| Design tokens | ✅ Reuse AppColors/Spacing/Typography |
| Simplicity | ✅ Bottom sheet, no new feature module |

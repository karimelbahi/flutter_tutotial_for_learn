# Quickstart: Navigation & Polish

**Feature**: 004-navigation-polish

## Prerequisites

Phases 7–9 complete (home, search, detail). `.env` configured.

```bash
flutter pub get
```

---

## Step 1 — Debug route guard

**Validate**:
- [ ] `flutter run` (debug) — FAB opens widget gallery
- [ ] `flutter run --release` — no FAB, `/dev/widget-preview` not registered

**Commit**: `chore(movies): gate dev widget preview behind debug flag`

---

## Step 2 — Back navigation

**Validate**:
- [ ] Home → Search → back → home
- [ ] Home → Detail → back → home
- [ ] Detail → Similar → Detail → back twice → previous detail → back → home

**Commit**: `feat(movies): add consistent back navigation on detail screen`

---

## Step 3 — Settings locale switcher

**Validate**:
- [ ] Tap settings on home → choose Arabic → labels update
- [ ] Switch back to English

**Commit**: `feat(movies): add settings locale switcher`

---

## Step 4 — i18n audit

**Validate**:
- [ ] No hardcoded user strings in `lib/app/` or screen widgets
- [ ] Invalid detail route shows localized message

**Commit**: `chore(movies): localize remaining hardcoded UI strings`

---

## Full acceptance

```bash
dart analyze lib/
flutter test
flutter run
```

**Commit**: `docs(movies): validate navigation polish against quickstart checklist`

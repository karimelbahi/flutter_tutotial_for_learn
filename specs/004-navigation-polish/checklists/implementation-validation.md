# Implementation Validation: Navigation & Polish

**Purpose**: Confirm `004-navigation-polish` is built and validated  
**Validated**: 2026-08-20  
**Feature**: [spec.md](../spec.md) · [quickstart.md](../quickstart.md)

## Static analysis & tests

- [x] `dart analyze lib/` — no issues
- [x] `flutter test` — 18 tests pass

## Quickstart steps (Steps 1–4)

- [x] Step 1 — Widget preview route gated with `kDebugMode`; debug FAB tooltip localized
- [x] Step 2 — Detail screen shows system back button via `CustomAppBar.showLogoLeading`
- [x] Step 3 — Settings bottom sheet switches en/ar on home and detail
- [x] Step 4 — Invalid route + generic cubit errors localized

## Spec acceptance (P1–P3)

- [x] P1 — Release builds exclude dev widget preview route; back navigation on search/detail
- [x] P2 — App chrome strings use `.tr()` keys; locale switch updates UI
- [x] P3 — Debug FAB visible only in debug; settings opens locale picker

## Manual validation (recommended)

- [ ] `flutter run --release` — no widget gallery FAB
- [ ] Home → Search → back; Home → Detail → back; similar movie stack unwind
- [ ] Settings → Arabic → verify home/search/detail labels
- [ ] Compare layouts to reference screenshots (`screenshoots/ss1–ss7.jpg`)

## Notes

- Locale preference is session-level (easy_localization); persist across restarts deferred to Phase 11.
- Widget preview screen file retained for debug learning; unreachable in release.

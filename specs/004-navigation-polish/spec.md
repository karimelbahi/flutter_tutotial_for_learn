# Feature Specification: Navigation & Polish

**Feature Branch**: `004-navigation-polish`

**Created**: 2026-08-20

**Status**: Complete

**Input**: User description: "Polish the MVP movie app: remove dev-only routes from release builds, consistent back navigation across screens, localize remaining hardcoded UI strings, add settings locale switcher (en/ar), and validate the full Home → Search → Detail → Similar flow matches the reference app."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Production-Ready Navigation (Priority: P1)

As a user, I want predictable back navigation and no debug screens in release builds so the app feels finished.

**Why this priority**: Broken back buttons and dev routes undermine trust in the core app.

**Independent Test**: Run a release/profile build and verify no widget gallery route; back from search and detail returns to the previous screen.

**Acceptance Scenarios**:

1. **Given** a release build, **When** the user navigates the app, **Then** the widget preview route is not registered.
2. **Given** the user opens search from home, **When** they press back, **Then** they return to home.
3. **Given** the user opens movie detail, **When** they press back, **Then** they return to the previous screen (home or search).
4. **Given** the user taps a similar movie, **When** they press back repeatedly, **Then** they unwind the detail stack correctly.

---

### User Story 2 - Bilingual UI Completeness (Priority: P2)

As a user, I want all visible labels in my chosen language so the app supports English and Arabic fully.

**Why this priority**: Remaining hardcoded strings break Arabic locale parity.

**Independent Test**: Switch locale to Arabic and walk all screens; no English-only system labels remain (except TMDB content).

**Acceptance Scenarios**:

1. **Given** Arabic locale, **When** the user views home, search, and detail, **Then** app chrome strings use Arabic translations.
2. **Given** the user opens settings, **When** they switch language, **Then** the UI updates without restart.
3. **Given** an invalid detail route, **When** it is shown, **Then** error text is localized.

---

### User Story 3 - Settings & Dev Tooling (Priority: P3)

As a learner, I want debug widget previews available only in debug builds and a simple settings entry for locale.

**Why this priority**: Keeps learning tools without shipping them to users.

**Independent Test**: Debug build shows FAB gallery; release build does not. Settings icon opens locale picker.

**Acceptance Scenarios**:

1. **Given** a debug build, **When** on home, **Then** the widget gallery FAB is visible.
2. **Given** a release build, **When** on home, **Then** no widget gallery FAB or route exists.
3. **Given** home, **When** the user taps settings, **Then** they can choose English or Arabic.

---

### Edge Cases

- What happens when settings is tapped on detail? Same locale sheet (global preference).
- What happens when locale changes on search screen? Hints and labels refresh via easy_localization rebuild.
- What happens when user deep-links invalid detail ID type? Localized invalid-route screen with back.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST register the widget preview route only in debug builds (`kDebugMode`).
- **FR-002**: System MUST show a back affordance on the movie detail screen when opened from another screen.
- **FR-003**: Search screen MUST retain system back navigation to home.
- **FR-004**: System MUST localize all user-facing app chrome strings (no hardcoded English in widgets/router).
- **FR-005**: System MUST provide a settings action on home that opens a locale picker (English / Arabic).
- **FR-006**: Locale choice MUST persist for the session via easy_localization.
- **FR-007**: System MUST keep existing loading, empty, and error states on home, search, and detail (no regressions).
- **FR-008**: System MUST document manual validation against reference screenshots in the implementation checklist.

### Key Entities

- **App settings**: Ephemeral locale preference (session-level via easy_localization).
- **Navigation stack**: Home → Search → Detail → Detail (similar) with standard pop behavior.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of app chrome strings on home, search, and detail use `.tr()` keys in en.json and ar.json.
- **SC-002**: Release build has zero registered dev-only routes.
- **SC-003**: Back navigation succeeds on search and detail in manual testing.
- **SC-004**: User can switch en ↔ ar from settings and see UI update immediately.
- **SC-005**: `dart analyze lib/` clean and `flutter test` passes after polish.

## Assumptions

- Locale persistence across app restarts is optional in v1 (session switch is sufficient).
- Reference app flow in `flutter-tmdbmovie-bloc-cubit` is the navigation benchmark.
- Widget preview screen file remains for debug/learning but is unreachable in release.

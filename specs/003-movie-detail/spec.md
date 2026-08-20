# Feature Specification: Movie Detail Screen

**Feature Branch**: `003-movie-detail`

**Created**: 2026-08-20

**Status**: Draft

**Input**: User description: "Build the full movie detail screen: backdrop carousel, title/year/runtime, poster with genre chips and overview, stats row (rating, revenue, status), cast horizontal list, similar movies row, popup menu (share/website). Match reference TMDB movie app. Replace detail placeholder from home and search navigation."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - View Movie Information (Priority: P1)

As a user, I want to open a movie and see its key information so I can decide if I want to watch it.

**Why this priority**: Core detail content (title, poster, overview, rating) delivers primary value.

**Independent Test**: Navigate from home or search to a known movie ID and verify title, poster, overview, and rating display.

**Acceptance Scenarios**:

1. **Given** the user taps a movie from home or search, **When** detail data loads, **Then** a backdrop image carousel is shown at the top.
2. **Given** detail is loaded, **When** the user views the header, **Then** title, release year, and runtime are visible.
3. **Given** detail is loaded, **When** the user scrolls the info section, **Then** poster, genre chips, and overview text are shown.
4. **Given** detail is loaded, **When** the user views stats, **Then** rating, revenue, and release status are displayed.

---

### User Story 2 - Browse Cast and Similar Movies (Priority: P2)

As a user, I want to see cast members and similar titles so I can explore related content.

**Why this priority**: Cast and recommendations extend discovery but depend on core detail loading first.

**Independent Test**: Open a popular movie detail and verify cast row and similar movies row load independently.

**Acceptance Scenarios**:

1. **Given** detail is open, **When** cast data loads, **Then** a horizontal list shows cast member photo (or placeholder), name, and character.
2. **Given** detail is open, **When** similar movies load, **Then** a labeled horizontal row of movie cards appears.
3. **Given** similar movies are shown, **When** the user taps a similar movie, **Then** the app opens detail for that movie ID.

---

### User Story 3 - Actions and Loading States (Priority: P3)

As a user, I want loading indicators, error recovery, and optional actions (share, visit website) so the screen feels complete and trustworthy.

**Why this priority**: Polish and edge cases; not required for first detail preview but expected in reference parity.

**Independent Test**: Simulate slow network and empty homepage; verify loading spinners and menu behavior.

**Acceptance Scenarios**:

1. **Given** detail is loading, **When** the user waits, **Then** a loading indicator is shown instead of blank content.
2. **Given** detail fails to load, **When** the error is handled, **Then** the user sees an error message with retry.
3. **Given** detail is loaded with a homepage URL, **When** the user selects "Visit Website" from the menu, **Then** the system opens the movie website externally.
4. **Given** cast or similar sections fail, **When** errors occur, **Then** other sections still display (independent loading).

---

### Edge Cases

- What happens when backdrop or poster images are missing? Placeholder is shown.
- What happens when overview is empty? Show localized empty overview message or hide section gracefully.
- What happens when revenue is zero? Display a dash or "USD -" like reference.
- What happens when user opens similar movie? Same detail screen reloads with new `movieId` (no stale data flash).
- What happens when cast list is empty? Section shows empty state or hides list without breaking layout.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST display a movie detail screen when the user taps any movie from home, search, or similar movies row.
- **FR-002**: System MUST fetch and display movie detail including backdrops, title, runtime, poster, genres, overview, rating, revenue, and status.
- **FR-003**: System MUST show an autoplay backdrop carousel reusing the cinematic carousel pattern from the reference app.
- **FR-004**: System MUST fetch and display a horizontal cast list (up to 15 members shown).
- **FR-005**: System MUST fetch and display a horizontal similar-movies list with ratings on cards.
- **FR-006**: System MUST navigate to detail for a new movie when a similar movie is tapped.
- **FR-007**: System MUST provide a popup menu with Share and Visit Website options (Share may be no-op in v1).
- **FR-008**: System MUST show section-level loading and error states for detail, cast, and similar data independently.
- **FR-009**: System MUST use the dark cinematic theme and design tokens consistent with home and search.
- **FR-010**: All user-facing labels MUST support English and Arabic via localization.
- **FR-011**: System MUST replace the detail placeholder screen with the real implementation.

### Key Entities

- **Movie detail**: Full movie record with images, genres, financial/status metadata, and overview.
- **Cast member**: Actor name, character name, profile image path.
- **Similar movie**: Same list-item shape as home/search movies (id, title, poster, rating).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can open detail from home or search and see core info within 3 seconds on a typical mobile network.
- **SC-002**: 100% of similar-movie taps open detail for the correct movie ID.
- **SC-003**: Cast and similar sections load independently — detail failure does not block cast/similar retry.
- **SC-004**: Layout matches reference structure: carousel → title → poster/overview → stats → cast → similar.
- **SC-005**: Back navigation returns to the previous screen (home or search).

## Assumptions

- TMDB API provides `/movie/{id}`, `/movie/{id}/credits`, `/movie/{id}/similar` endpoints.
- Detail request uses `append_to_response=images` for backdrop carousel (per existing `AppConfig`).
- Reference app at `flutter-tmdbmovie-bloc-cubit` defines target layout.
- Share action is stubbed (no native share sheet) unless added in a later iteration.
- `url_launcher` opens homepage in external browser.

# Reference Repository

Local clone of the design/UX reference app used while building this project.

## Path

```
/Users/karimelbahi/Programming/Android/Study/Flutter/flutter-tmdbmovie-bloc-cubit
```

**GitHub:** [ihsaninh/flutter-tmdbmovie-bloc-cubit](https://github.com/ihsaninh/flutter-tmdbmovie-bloc-cubit)

**Sibling to this project:**
```
Flutter/
├── flutter_tutotial_for_learn/     ← our app (this repo)
└── flutter-tmdbmovie-bloc-cubit/   ← reference clone
```

## Refresh the clone

```bash
cd /Users/karimelbahi/Programming/Android/Study/Flutter/flutter-tmdbmovie-bloc-cubit
git pull
```

## Re-clone if missing

```bash
git clone https://github.com/ihsaninh/flutter-tmdbmovie-bloc-cubit.git \
  /Users/karimelbahi/Programming/Android/Study/Flutter/flutter-tmdbmovie-bloc-cubit
```

## Key files to reference

| Reference path | Purpose | Our target |
|----------------|---------|------------|
| `lib/constants/colors.dart` | Color palette | `lib/core/constants/app_colors.dart` |
| `lib/widgets/movie_card.dart` | Poster card + rating | `lib/features/movies/presentation/widgets/` |
| `lib/widgets/carousel_item.dart` | Hero banner | same |
| `lib/widgets/section_header.dart` | Section titles | same |
| `lib/widgets/dot_indicator.dart` | Carousel dots | same |
| `lib/widgets/custom_appbar.dart` | App bar | same |
| `lib/widgets/search_form_field.dart` | Search input | same |
| `lib/widgets/list_tile_search.dart` | Search results | same |
| `lib/screens/movie_home.dart` | Home layout | `lib/features/movies/presentation/screens/` |
| `lib/screens/movie_detail.dart` | Detail layout | same |
| `lib/screens/search.dart` | Search screen | same |
| `screenshoots/` | UI screenshots (ss1–ss7.jpg) | Visual comparison while coding |

## Open in Finder

```bash
open /Users/karimelbahi/Programming/Android/Study/Flutter/flutter-tmdbmovie-bloc-cubit
```

## Open in Cursor

**File → Open Folder…** → paste the path above.

## Usage rule

- **Read** from the reference for layout, spacing, and widget structure.
- **Write** into `flutter_tutotial_for_learn` using Clean Architecture + modern Dart.
- Do not copy-paste blocs/repositories directly — adapt into `lib/features/movies/`.

import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import 'widget_preview_support.dart';

/// One row in the search results list — poster, title, release year.
///
/// Ported from reference `lib/widgets/list_tile_search.dart`.
/// Pass [posterPath] from [Movie.posterPath] (nullable — shows placeholder).
class ListTileSearch extends StatelessWidget {
  const ListTileSearch({
    super.key,
    required this.title,
    required this.releaseDate,
    required this.onTap,
    this.posterPath,
  });

  final String? posterPath;
  final String title;
  final String releaseDate;
  final VoidCallback onTap;

  static String displayReleaseYear(String releaseDate) {
    if (releaseDate.length > 3) {
      return releaseDate.substring(0, 4);
    }
    return releaseDate;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: SizedBox(
        width: AppSpacing.searchListPosterWidth,
        height: AppSpacing.searchListPosterHeight,
        child: _SearchPosterImage(posterPath: posterPath),
      ),
      title: Text(
        title,
        style: AppTypography.movieCardTitle,
      ),
      subtitle: Text(
        displayReleaseYear(releaseDate),
        style: AppTypography.movieCardMeta,
      ),
    );
  }
}

class _SearchPosterImage extends StatelessWidget {
  const _SearchPosterImage({this.posterPath});

  final String? posterPath;

  @override
  Widget build(BuildContext context) {
    if (posterPath == null || posterPath!.isEmpty) {
      return const ColoredBox(
        color: AppColors.martinique,
        child: Icon(
          Icons.movie_outlined,
          color: AppColors.placeholder,
        ),
      );
    }

    return Image.network(
      AppConfig.imageUrl(posterPath!),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const ColoredBox(
        color: AppColors.martinique,
        child: Icon(
          Icons.broken_image_outlined,
          color: AppColors.placeholder,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// @Preview — run: flutter widget-preview start
// ---------------------------------------------------------------------------

@Preview(
  name: 'With poster and year',
  group: 'ListTileSearch',
  wrapper: moviesFullWidthWrapper,
)
Widget listTileSearchWithPosterPreview() {
  return ListTileSearch(
    posterPath: '/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
    title: 'The Dark Knight',
    releaseDate: '2008-07-18',
    onTap: previewNoOp,
  );
}

@Preview(
  name: 'Missing poster placeholder',
  group: 'ListTileSearch',
  wrapper: moviesFullWidthWrapper,
)
Widget listTileSearchPlaceholderPreview() {
  return ListTileSearch(
    title: 'Untitled Project',
    releaseDate: 'TBA',
    onTap: previewNoOp,
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import 'widget_preview_support.dart';

/// Vertical poster card used in horizontal movie rows (genres, top rated, upcoming).
///
/// Ported from reference `lib/widgets/movie_card.dart`.
///
/// - Pass [posterPath] from [Movie.posterPath] (nullable — shows placeholder).
/// - Pass [rating] for star row (TMDB 0–10 scale); otherwise [subtitle] is shown.
/// - [onTap] will navigate to detail in a later step.
class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.title,
    required this.onTap,
    this.posterPath,
    this.rating,
    this.subtitle,
  });

  final String title;
  final String? posterPath;
  final double? rating;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(
          top: AppSpacing.md,
          right: AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.moviePosterRadius),
              child: Stack(
                children: [
                  _PosterImage(posterPath: posterPath),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: AppColors.inkSplash,
                        highlightColor: AppColors.inkHighlight,
                        onTap: onTap,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSpacing.moviePosterWidth,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.md),
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: AppTypography.movieCardTitle,
                ),
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSpacing.moviePosterWidth,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: rating == null
                    ? Text(
                        subtitle ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: AppTypography.movieCardMeta,
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            rating!.toStringAsFixed(1),
                            style: AppTypography.movieCardTitle.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: AppSpacing.xs),
                            child: RatingBarIndicator(
                              rating: rating! / 2,
                              itemCount: 5,
                              itemSize: AppSpacing.lg,
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: AppColors.rating,
                                size: AppSpacing.lg,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PosterImage extends StatelessWidget {
  const _PosterImage({this.posterPath});

  final String? posterPath;

  @override
  Widget build(BuildContext context) {
    if (posterPath == null || posterPath!.isEmpty) {
      return const SizedBox(
        width: AppSpacing.moviePosterWidth,
        height: AppSpacing.moviePosterHeight,
        child: Icon(
          Icons.movie_outlined,
          size: 100,
          color: AppColors.placeholder,
        ),
      );
    }

    return Image.network(
      AppConfig.imageUrl(posterPath!),
      fit: BoxFit.cover,
      width: AppSpacing.moviePosterWidth,
      height: AppSpacing.moviePosterHeight,
      errorBuilder: (context, error, stackTrace) => const SizedBox(
        width: AppSpacing.moviePosterWidth,
        height: AppSpacing.moviePosterHeight,
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
  name: 'Two-line title + rating',
  group: 'MovieCard',
  wrapper: moviesDarkScaffoldWrapper,
)
Widget movieCardLongTitlePreview() {
  return MovieCard(
    title: 'Spider-Man: Brand New Day',
    posterPath: '/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
    rating: 7.9,
    onTap: previewNoOp,
  );
}

@Preview(
  name: 'Star rating row',
  group: 'MovieCard',
  wrapper: moviesDarkScaffoldWrapper,
)
Widget movieCardWithRatingPreview() {
  return MovieCard(
    title: 'The Dark Knight',
    posterPath: '/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
    rating: 8.5,
    onTap: previewNoOp,
  );
}

@Preview(
  name: 'Release year subtitle',
  group: 'MovieCard',
  wrapper: moviesDarkScaffoldWrapper,
)
Widget movieCardWithSubtitlePreview() {
  return MovieCard(
    title: 'Inception',
    posterPath: '/9o9kRwe0IzzC8Qp8WAW8b8MrhTh.jpg',
    subtitle: '2010',
    onTap: previewNoOp,
  );
}

@Preview(
  name: 'Missing poster placeholder',
  group: 'MovieCard',
  wrapper: moviesDarkScaffoldWrapper,
)
Widget movieCardPlaceholderPreview() {
  return MovieCard(
    title: 'No Poster Yet',
    subtitle: 'TBA',
    onTap: previewNoOp,
  );
}
